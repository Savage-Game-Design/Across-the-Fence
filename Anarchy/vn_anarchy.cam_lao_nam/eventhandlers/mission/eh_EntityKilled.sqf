/*
  Author: Aaron Clark

  Description:
	Entity death event tracking for stats

  Parameter(s):
*/
params ["_unit", "_killer", "_instigator", "_useEffects"];

private _kill_type = "deaths";

private _is_unit_player = isPlayer _unit;
private _is_killer_player = isPlayer _killer;

// TODO: look into how _instigator works with other players in mp, maybe able to use for kill assist tracking and others...
// if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill -
// if (isNull _instigator) then {_instigator = _killer}; // player driven vehicle road kill

// record stats
if (_is_unit_player) then
{
	// record player death
	[_unit,_kill_type] call vn_an_fnc_change_player_stat;

	if (_is_killer_player) then
	{
		// if _killer is self add 1 to : suicides
		if (_unit isEqualTo _killer) then
		{
			_kill_type = "suicides";
			[_killer,_kill_type] call vn_an_fnc_change_player_stat;
		}
		else
		{
			// _unit is another player report as - friendlyfire
			_kill_type = "friendlyfire";
			[_killer,_kill_type] call vn_an_fnc_change_player_stat;
		};
	};


} else {

	if (_is_killer_player) then
	{

		if (_unit isKindOf "Man") then
		{
			// if _unit is AI check if civilian or enemy
			if ([side _unit,side _killer] call BIS_fnc_sideIsFriendly) then
			{
				// if civ record as - murder
				_kill_type = "murders";
				[_killer,_kill_type] call vn_an_fnc_change_player_stat;
			}
			else
			{
				// if enemy record as - kill
				_kill_type = "kills";
				[_killer,_kill_type] call vn_an_fnc_change_player_stat;
				// [_killer,1] call vn_an_fnc_player_rank;
			};

		}
		else
		{
			// if vehicle record as - vehiclekill
			_kill_type = "vehiclekills";
			[_killer,_kill_type] call vn_an_fnc_change_player_stat;

			// TODO boat

			// TODO air to air

		};
	};
};

diag_log format["EntityKilled mEH: %1 - %2", _kill_type, _this];
