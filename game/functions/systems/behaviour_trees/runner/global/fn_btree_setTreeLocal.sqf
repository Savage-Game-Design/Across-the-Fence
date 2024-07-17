/*
    File: fn_btree_setTreeLocal.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2024-05-03
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
        [group cursorObject, _compiledTree] call vgm_g_fnc_btree_setTreeLocal;
 */

params ["_group", "_tree"];

private _currentTree = _group getVariable "vgm_l_btree_current";

if (!isNil "_currentTree" && {isNil "_tree" || { _currentTree isNotEqualTo _tree }}) then {
    private _extern_btreeState = _group getVariable "vgm_l_btree_state";
    private _extern_stack = _extern_btreeState get "stack";

    // Make sure all nodes are allowed to clean themselves up.
    [-1] call vgm_g_fnc_btree_unwindStackUpToIndex;

    // Allow nodes to cleanup anything they did when the tree was assigned.
    [_group, _extern_btreeState get "blackboard"] call vgm_g_fnc_btree_callOnTreeUnassignedCallbacks;

    _group setVariable ["vgm_l_btree_current", nil];
};

if !(_group getVariable ["vgm_l_btree_isGroupSetup", false]) then {
    // Make sure tree is cleaned up when the group is deleted.
    _group addEventHandler ["Deleted", {
        params ["_group"];
        [_group] call vgm_g_fnc_btree_setTreeLocal;
    }];

    // Make sure tree is cleaned up when the group changes locality.
    // Behaviour tree system only works on local groups.
    _group addEventHandler ["Local", {
        params ["_group", "_local"];

        // Cleanup the behaviour tree on the old host.
        // Makes sure the nodes are correctly aborted, and unassigned callbacks fire.
        // TODO - Might need to consider race conditions here, if this gets done *after* the assignment on other host,
        // and anything behaves globally.
        if (!_local) then {
            [_group] call vgm_g_fnc_btree_setTreeLocal;
        };
    }];

    _group setVariable ["vgm_l_btree_isGroupSetup", true];
};

if (!isNil "_tree") then {
    _group setVariable ["vgm_l_btree_current", _tree];
    private _newBlackboard = createHashMap;
    _group setVariable ["vgm_l_btree_state", createHashMapFromArray [
        ["stack", []],
        ["blackboard", _newBlackboard]
    ]];
    _group setVariable ["vgm_l_btree_log", []];

    [_group, _newBlackboard] call vgm_g_fnc_btree_callOnTreeAssignedCallbacks;
};
