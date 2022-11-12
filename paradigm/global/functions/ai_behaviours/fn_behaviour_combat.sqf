/*
	File: fn_behaviour_combat.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		"Combat" behaviour. Called while the AI is in combat, to make them engage effectively.
	
	Parameter(s):
		_localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
	
	Returns:
		Behaviour executed successfully [BOOL]
	
	Example(s):
		_group call para_g_fnc_behaviour_combat;
 */

params ["_group"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Combat Behaviour Execution", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (speedMode _group != "FULL") then {
	_group setSpeedMode "FULL";
};

if (behaviour leader _group != "COMBAT") then {
	_group setBehaviour "COMBAT";
};

if (combatMode _group != "RED") then {
	_group setCombatMode "RED";
};

{
	if (unitPos _x != "AUTO") then {
		_x setUnitPos "AUTO";
	};
} forEach units _group;

true