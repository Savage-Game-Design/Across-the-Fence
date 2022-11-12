/*
    File: fn_allow_damage_persistent.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Sets allow damage on an object, and persists it regardless of which client it switches to.
    
    Parameter(s):
		_object - Object to apply allowDamage to [OBJECT]
		_allowDamage - Whether or not to allow damage [BOOLEAN]
    
    Returns:
		Nothing
    
    Example(s):
		[_myObject, true] call para_s_fnc_allow_damage_persistent;
*/

params ["_object", "_allowDamage"];

if !(_object getVariable ["para_l_allow_damage_persistence_applied", false]) then 
{
	//Use the stacked remoteExec, so we don't interfere with anything else JIP'ing
	[[_object], "para_g_fnc_add_allow_damage_persistence", 0, _object] call para_s_fnc_remoteExecCall_jip_obj_stacked;
};

//Tell persistence handler what state it should be in.
_object setVariable ["para_g_allow_damage", _allowDamage];
[_object, _allowDamage] remoteExecCall ["allowDamage", _object];

