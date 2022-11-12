/*
	File: fn_behaviour_pursue.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		When called on a group, makes the group pursue a specific target with Seek and Destroy orders.
	
	Parameter(s):
		_group - Group to perform this behaviour. Must have 'pursuitTarget' set on the group.
	
	Returns:
		Behaviour executed successfully [BOOl]
	
	Example(s):
		[_group] call para_g_fnc_behaviour_pursue
 */

params ["_group", "_target"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Pursue Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if !([_group, _target] call para_g_fnc_behaviour_is_valid_target) exitWith {false};


if (speedMode _group != "FULL") then {
	_group setSpeedMode "FULL";
};

if (behaviour leader _group != "AWARE") then {
	_group setBehaviour "AWARE";
};

private _desiredCombatMode = "WHITE";
if (leader _group distance2D _target < 150) exitWith {
	_desiredCombatMode = "RED";
};

if (combatMode _group != _desiredCombatMode) then {
	_group setCombatMode _desiredCombatMode;
};

[_group, "AUTO"] call para_g_fnc_behaviour_set_group_stance;

[_group, getPos _target , "FULL"] call para_g_fnc_behaviour_move_to;

true
