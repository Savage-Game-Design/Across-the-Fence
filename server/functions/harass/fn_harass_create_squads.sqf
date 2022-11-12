/*
	File: fn_harass_create_squads.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		This function should not be called outside of the AI subsystem.
		Maintains the dynamic harass squads that attack players in the field.
		Sets a 'harass level' on players, to mark how harassed they are right now. '1' is the target.
		Less than 1 is under-harassed, more than 1 is over-harassed.

	Parameter(s): none

	Returns: nothing

	Example(s): none
*/
{
	private _side = _x;
	private _enemySides = [west, east, independent, civilian] select {_x getFriend _side < 0.6};
	private _friendlyPlayers = playableUnits select {side group _x == _side};
	private _enemyUnits = allUnits select {alive _x && (side group _x in _enemySides)};
    private _harassTraitSet = false;

    //Figure out if harassTraitSet is True
    (getAllUnitTraits player) apply {if("harrassable" in _x) exitWith {_harassTraitSet = true}};

	//Figure out which players can be harassed
	private _harassablePlayers = _friendlyPlayers select {
		private _player = _x;
		alive _player
		//!(Player is in a vehicle and travelling over 29 km/h) - Don't harass moving vehicles.
		&& !(vehicle _player != _player && (canMove vehicle _player))
		//Player is on a combat side.
		&& side group _player in [west, east, independent]
		//Player has harrass flag set as true
		&& (_player getUnitTrait "harassable")
	};

	_harassablePlayers = [_harassablePlayers] call para_interop_fnc_harass_filter_target_players;

	//Initialise the harassment variables for all players - we'll be using them later.
	{
		private _enemiesInArea = (_enemyUnits inAreaArray [getPos _x, 200, 200]);
		private _friendlyPlayersInArea = (_harassablePlayers inAreaArray [getPos _x, 200, 200]);

		_x setVariable ["harass_level", 0];
		//Only records harassable players. This avoids us messing around with people in aircraft, etc.
		_x setVariable ["harass_nearbyFriendlyPlayers", _friendlyPlayersInArea];
		_x setVariable ["harass_nearbyEnemies", _enemiesInArea];
	} forEach _friendlyPlayers;

	//Calculate the current harassment level for each player.
	//Factor in nearby allies, nearby enemies, and enemies currently on their way to them (where possible).
	private _aiPerChallengeLevel = [1, 1] call para_g_fnc_ai_scale_to_player_count;
	{
		//Apply a value that decreases over time, if they've had harass squads recently sent.
		//Avoids saturating a player with harass squads, since we don't count squads that are more than X m away,
		//It's theoretically possible there's an entire attack on its way
		//If harass delay is too short, we risk spamming the players with AI.

		private _enemyRatioComponent =
			(count (_x getVariable "harass_nearbyEnemies") /  count (_x getVariable "harass_nearbyFriendlyPlayers"))
			/ _aiPerChallengeLevel;

		_x setVariable ["harass_level", _enemyRatioComponent];
	} forEach _harassablePlayers;

	//Find players that aren't harassed enough.
	private _friendlyPlayersToHarass = _harassablePlayers select {_x getVariable "harass_level" < 1};

	//Keep occupied FOBs harassed
	private _playersToRemove = [];
	{
		private _marker = _x getVariable "para_g_base_marker";
		private _players = _harassablePlayers inAreaArray _marker;
		private _lastAttack = _x getVariable ["harass_lastSent", 0];
		_playersToRemove append _players;

		if (count _players > 0 && _lastAttack <= (serverTime - 10 * 60)) then {
			private _attackIntensity = 1;
			switch (missionNamespace getVariable ["para_s_time_of_day", "Day"]) do {
				case "Dawn": {_attackIntensity = 1};
				case "Day": {_attackIntensity = .75};
				case "Dusk": {_attackIntensity = 1.25};
				case "Night": {_attackIntensity = 1.5};
			};
			[getMarkerPos _marker, _attackIntensity, 1] call para_s_fnc_ai_obj_request_attack;
		};
		_x setVariable ["harass_lastSent", serverTime];
	} forEach para_g_bases;

	private _harassablePlayers = _harassablePlayers - _playersToRemove;

	private _lastPlayersToHarassLength = -1;

	//Start sending harass squads at players, updating the harassment values as we do.
	//Abort if nothing was removed from the array, as a failsafe.
	while {!(_friendlyPlayersToHarass isEqualTo []) && count _friendlyPlayersToHarass != _lastPlayersToHarassLength} do {
		_lastPlayersToHarassLength = count _friendlyPlayersToHarass;
		private _target = selectRandom _friendlyPlayersToHarass;

		private _nearbyPlayers = _target getVariable "harass_nearbyFriendlyPlayers";
		private _totalHarassment = 0;
		private _totalChallengeRating = 0;
		private _totalFrequencyMultiplier = 0;
		private _totalTimeSinceLastHarass = 0;
		{
			_totalHarassment = _totalHarassment + (_x getVariable "harass_level");
			private _difficulty = (_x call para_s_fnc_harass_calculate_difficulty);
			_totalChallengeRating = _totalChallengeRating + (_difficulty select 0);
			_totalFrequencyMultiplier = _totalFrequencyMultiplier + (_difficulty select 1);
			_totalTimeSinceLastHarass = _totalTimeSinceLastHarass + (serverTime - (_x getVariable ["harass_lastSent", 0]));
		} forEach _nearbyPlayers;

		private _averageHarassment = _totalHarassment / count _nearbyPlayers;
		private _averageChallengeRating = _totalChallengeRating / count _nearbyPlayers;
		private _averageFrequencyMultiplier = _totalFrequencyMultiplier / count _nearbyPlayers;
		private _averageTimeSinceLastHarass = _totalTimeSinceLastHarass / count _nearbyPlayers;
		/*["Group: %1", _nearbyPlayers apply {name _x}] call BIS_fnc_logFormat;
		["Average harassment: %1", _averageHarassment] call BIS_fnc_logFormat;
		["Average Challenge Rating: %1", _averageChallengeRating] call BIS_fnc_logFormat;
		["Average Frequency Multiplier: %1", _averageFrequencyMultiplier] call BIS_fnc_logFormat;
		["Average Time Since Last Harass: %1", _averageTimeSinceLastHarass] call BIS_fnc_logFormat;*/

		//Check whether it's been long enough, and we can send them.
		//Force a minimum delay, to avoid spamming players with AI.
		private _sufficientTimeHasPassed = _averageTimeSinceLastHarass > ((para_s_harassDelay * _averageFrequencyMultiplier) max para_s_harassMinDelay);

		//Don't need to update their harassment values, as we're just going to delete from the harass list.

		//Makes sure we have the minimum harassment to make it worthwhile to send a squad.
		private _challengeDifference = _averageChallengeRating - _averageHarassment;
		if (_sufficientTimeHasPassed && _averageHarassment <= 0.5) then {
			//Harassment is between 0 and 1, where 1 is 'optimally harassed'. Use it to set the difficulty parameter here.
			//["Requesting pursuit with %1 unit scaling", [count _nearbyPlayers, _challengeDifference]] call BIS_fnc_logFormat;
			private _enemySide = [_side, getPos _target] call para_interop_fnc_harass_get_enemy_side;
			[_nearbyPlayers, _challengeDifference, 1, _enemySide] call para_s_fnc_ai_obj_request_pursuit;

			private _time = serverTime;
			{
				_x setVariable ["harass_lastSent", _time];
				_x setVariable ["harass_lastHarassChallengeRating", _averageChallengeRating];
			} forEach _nearbyPlayers;
		};

		_friendlyPlayersToHarass = _friendlyPlayersToHarass - _nearbyPlayers;
	};
} forEach [west, east, independent];

//["Finished harassing players"] call BIS_fnc_logFormat;
