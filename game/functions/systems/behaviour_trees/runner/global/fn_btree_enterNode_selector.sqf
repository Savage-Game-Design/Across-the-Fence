#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_enterNode_selector.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Handles entering a "selector" type node.

    Parameter(s):
        _stackFrame - Stack frame for the current node [HASHMAP]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */


params ["_stackFrame"];

[[0], ACTION_RUN_CHILD]
