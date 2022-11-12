/*
	File: fn_behaviour_set_group_stance.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Set Group Stance' behaviour. sets whether a   group   of units should be prone, stood or auto.
	
	Parameter(s):
		_group - Group to execute the behaviour on
		_pos - Position to put them in. One of 'UP', 'DOWN', 'MIDDLE' or 'AUTO'.
	
	Returns:
		True if units are already in that stance, false otherwise. <BOOL>
	
	Example(s):
		[_group, "AUTO"] call para_g_fnc_behaviour_set_unit_pos
 */

params ["_group", "_pos"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Set Group Stance Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (_group getVariable ["unitPos", ""] != _pos) exitWith {
	{
		_x setUnitPos _pos;
	} forEach units _group;
	_group setVariable ["unitPos", _pos];
	false
};

true
