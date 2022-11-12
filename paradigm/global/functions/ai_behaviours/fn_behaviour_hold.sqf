/*
	File: fn_behaviour_hold.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
	   'Defend' behaviour. Running this on a group has them defend a point.
	
	Parameter(s):
	   _group - Group to run the behaviour on. Needs 'defendPos' set in AGL format.
	   _defendPos - Position to defend in AGL format.
	
	Returns:
		Behaviour execution succeeded [BOOL]
	
	Example(s):
		[_group] call para_g_fnc_behaviour_hold
 */

params ["_group", "_defendPos"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Hold Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (speedMode _group != "NORMAL") then {
	_group setSpeedMode "NORMAL";
};

if (combatMode _group != "YELLOW") then {
	_group setCombatMode "YELLOW";
};

if (behaviour leader _group != "AWARE") then {
	_group setBehaviour "AWARE";
};

if (formation _group != "LINE") then {
	_group setFormation "LINE";
};

[_group, "AUTO"] call para_g_fnc_behaviour_set_group_stance;

if (leader _group distance2D _defendPos > (_group getVariable "behaviourHoldRadius")) then {
	[_group, _defendPos, "FULL"] call para_g_fnc_behaviour_move_to;
} else {
	[_group, "BEHAVIOUR_DEFEND_HOLD", "HOLD", AGLtoASL _defendPos, -1] call para_g_fnc_behaviour_waypoint;
};

true