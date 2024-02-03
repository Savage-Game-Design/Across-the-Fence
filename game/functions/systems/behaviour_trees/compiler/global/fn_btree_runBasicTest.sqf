#include "..\definitions.inc"
#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_runBasicTest.sqf
    Author: Savage Game Design
    Date: 2024-01-26
    Last Update: 2024-02-03
    Public: Yes

    Description:
        Performs a basic test of the behaviour tree system.

    Parameter(s):
        None

    Returns:

    Example(s):
        [] call vgm_g_fnc_btree_runBasicTest;
 */

private _extern_treeAssignedCalled = false;
private _extern_treeUnassignedCalled = false;

private _testTreeAssignmentNode = {
    params ["_params", "_children"];

    private _action = _this call vgm_g_fnc_btree_action_basic;
    _action set ["onTreeAssigned", {
        params ["_group"];
        _extern_treeAssignedCalled = true;
    }];

    _action set ["onTreeUnassigned", {
        params ["_group"];
        _extern_treeUnassignedCalled = true;
    }];

    _action
};

private _exampleTree =
[DECORATOR(basicService), [], [
    [SELECTOR, [["name", "root selector"]], [
        [DECORATOR(alwaysFail), [], [
            [DECORATOR(basic), [], [
                [ACTION(basic), []]
            ]]
        ]],
        [SEQUENCE, [["name", "fail before last child"]], [
            [ACTION(basic), []],
            [DECORATOR(alwaysFail), [], [
                [ACTION(basic), []]
            ]],
            [ACTION(basic), [["name", "won't run"]]]
        ]],
        // Infinite loop means the tree doesn't ever return to root.
        // Allows testing service and interrupt behaviour.
        [DECORATOR(loopInfinitely), [], [
            [ACTION(basic), []]
        ]],
        [_testTreeAssignmentNode, []]
    ]]
]]
;

private _compiledTree = [_exampleTree] call vgm_g_fnc_btree_compileTree;

private _testGroup = createGroup civilian;

[_testGroup, _compiledTree] call vgm_g_fnc_btree_setTree;

[_testGroup] call vgm_g_fnc_btree_tickGroup;
[_testGroup] call vgm_g_fnc_btree_tickGroup;

// Change the tree so the UnassignTree callbacks get called.
private _alternateTree = [ACTION(basic), []] call vgm_g_fnc_btree_compileTree;
[_testGroup, _alternateTree] call vgm_g_fnc_btree_setTree;

private _result = createHashMap;

_result set ["onTreeAssignedCalled", _extern_treeAssignedCalled];
_result set ["onTreeUnassignedCalled", _extern_treeUnassignedCalled];
_result set ["log", (_group getVariable "vgm_l_btree_log") joinString endl];
_result set ["compiledTree", _compiledTree];

deleteGroup _testGroup;

_result
