/*
	File: fn_behaviour_set_unit_stance.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Set Unit Stance' behaviour. sets whether a unit should be prone, stood or auto.
		 Needs to be used instead of 'setUnitPos' in order for 'behaviour_set_group_stance' to work correctly.
	
	Parameter(s):
		_unit - Unit to execute the behaviour on
		_pos - Position to put them in. One of 'UP', 'DOWN', 'MIDDLE' or 'AUTO'.
	
	Returns:
		True if unit is already in that stance, false otherwise. <BOOL>
	
	Example(s):
		[_group, "AUTO"] call para_g_fnc_behaviour_set_unit_pos
 */

params ["_unit", "_pos"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Set Unit Stance Behaviour Execution - %2", group _unit getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (unitPos _x != _pos) exitWith {
	_x setUnitPos _pos;
	if (group _unit getVariable ["unitPos", ""] != _pos) then {
		//Set it to "", because the group isn't in a consistent position.
		group _unit setVariable ["unitPos", ""];
	};
	false
};

true
