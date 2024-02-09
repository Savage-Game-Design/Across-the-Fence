/*
    File: fn_ai_run_behaviours_all_groups.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Executes main AI behaviour on all appropriate groups, once.

    Parameter(s):
		None

    Returns:
		None

    Example(s):
        [parameter] call vn_fnc_myFunction
*/

{
	private _group = _x;
	[_group] call vgm_g_fnc_btree_tickGroup;
} forEach (allGroups select {local _x && {_x getVariable ["vgm_l_btree_current", []] isNotEqualTo []}});
