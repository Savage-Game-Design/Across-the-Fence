/*
    File: fn_btree_setTree.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2024-02-08
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
    private _extern_btreeState = _group getVariable "vgm_l_btree_state";
    private _extern_stack = _extern_btreeState get "stack";

    // Make sure all nodes are allowed to clean themselves up.
    [-1] call vgm_g_fnc_btree_unwindStackUpToIndex;

    // Allow nodes to cleanup anything they did when the tree was assigned.
    [_group, _extern_btreeState get "blackboard"] call vgm_g_fnc_btree_callOnTreeUnassignedCallbacks;
};

_group setVariable ["vgm_l_btree_current", _tree];
private _newBlackboard = createHashMap;
_group setVariable ["vgm_l_btree_state", createHashMapFromArray [
    ["stack", []],
    ["blackboard", _newBlackboard]
]];
_group setVariable ["vgm_l_btree_log", []];

[_group, _newBlackboard] call vgm_g_fnc_btree_callOnTreeAssignedCallbacks;
