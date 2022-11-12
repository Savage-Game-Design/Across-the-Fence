/*
    File: fn_behaviour_add_player_event_handlers.sqf
    Author:  Savage Game Design
    Public: Yes
	Locality: Server
    
    Description:
        Adds event handlers to a player that allow AI to respond to their actions.
		!!**Currently unused**!!
    
    Parameter(s):
        _unit - Player to add event handler too
    
    Returns:
        None
    
    Example(s):
		[allPlayers # 0] call para_g_fnc_behaviour_add_player_event_handlers
*/

params ["_unit"];

if (isNil "para_g_behaviour_firedCooldown") then {
	para_g_behaviour_firedCooldown = 30;
	para_g_behaviour_firedDetectionDistance = 200;
};

_unit addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle"];

	if (_unit getVariable ["behaviourNextFireEvent", 0] < serverTime) then {
		_unit setVariable ["behaviourNextFireEvent", serverTime + para_g_behaviour_firedCooldown];
		[_unit] spawn {
			private _nearbyUnits = allPlayers inAreaArray [getPos _this, para_g_behaviour_firedDetectionDistance, para_g_behaviour_firedDetectionDistance, 0, false];
			{ _x setVariable ["behaviourNextFireEvent", serverTime + para_g_behaviour_firedCooldown] } forEach _nearbyUnits;
			private _nearbyEnemies = 
				allUnits inAreaArray [getPos _this, para_g_behaviour_firedDetectionDistance, para_g_behaviour_firedDetectionDistance, 0, false]
				select {side _x == east};
			private _groups = [];
			{ _groups pushBackUnique group _x } forEach _nearbyEnemies;

			{
				private _firedEvents = _x getVariable ["nearbyShots", []];
				_firedEvents pushBack [_this, serverTime];
				_x setVariable ["nearbyShots", _firedEvents, true];
			} forEach _groups;
		};
	};
}];