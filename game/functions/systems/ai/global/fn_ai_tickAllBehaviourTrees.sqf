/*
    File: fn_ai_tickAllBehaviourTrees.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Executes main AI behaviour on all appropriate groups, once.

    Parameter(s):
		None

    Returns:
		None

    Example(s):
        [] call vgm_g_fnc_ai_tickAllBehaviourTrees
        // or
        ["btree_runner", vgm_g_fnc_ai_tickAllBehaviourTrees, [], 5] call para_g_fnc_scheduler_add_job;
*/

{
	private _group = _x;
	[_group] call vgm_g_fnc_btree_tickGroup;
} forEach (allGroups select {local _x && {_x getVariable ["vgm_l_btree_current", []] isNotEqualTo []}});
