#include "..\definitions.inc"
#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_runBasicTest.sqf
    Author: Savage Game Design
    Date: 2024-01-26
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Performs a basic test of the behaviour tree system.

    Parameter(s):
        None

    Returns:

    Example(s):
        [] call vgm_g_fnc_btree_runBasicTest;
 */

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
        ]]
    ]]
]]
;

private _compiledTree = [_exampleTree] call vgm_g_fnc_btree_compileTree;

private _testGroup = createGroup civilian;

[_testGroup, _compiledTree] call vgm_g_fnc_btree_setTree;

[_testGroup] call vgm_g_fnc_btree_tickGroup;
[_testGroup] call vgm_g_fnc_btree_tickGroup;

[
    _compiledTree,
    _testGroup
]
