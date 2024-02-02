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
[SELECTOR, [["name", "root selector"]], [
    [DECORATOR(basic), [], [
        [ACTION(basic), []]
    ]],
    [ACTION(basic), []],
    [SEQUENCE, [["name", "dont execute last child"]], [
        [ACTION(basic), []],
        [DECORATOR(alwaysFail), [], [
            [ACTION(basic), []]
        ]],
        [ACTION(basic), [["name", "won't run"]]]
    ]]
]];

private _compiledTree = [_exampleTree] call vgm_g_fnc_btree_compileTree;

private _testGroup = createGroup civilian;

[_testGroup, _compiledTree] call vgm_g_fnc_btree_setTree;

[_testGroup] call vgm_g_fnc_btree_tickGroup;

[
    _compiledTree,
    _testGroup
]
