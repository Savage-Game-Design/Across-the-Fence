/*
    File: fn_btree_setTree.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: Yes

    Description:
        Sets the behaviour tree a group should execute.
        Note: Aborts any currently executing behaviour tree.

    Parameter(s):
        _group - Group to set the tree on [GROUP]
        _tree - Tree to run [HashMap]

    Returns:
        Nothing

    Example(s):
        [group cursorObject, _compiledTree] call vgm_g_fnc_btree_setTree;
 */

params ["_group", "_tree"];

private _currentTree = _group getVariable "vgm_l_btree_current";

if (!isNil "_currentTree" && { _currentTree isNotEqualTo _tree }) then {
    // TODO - Make this function. Abort the full stack.
	//[_group] call vgm_g_fnc_btree_abortCurrentTree;
};

_group setVariable ["vgm_l_btree_current", _tree];
_group setVariable ["vgm_l_btree_state", createHashMapFromArray [
    ["stack", []],
    ["blackboard", createHashMap]
]];
_group setVariable ["vgm_l_btree_log", []];


