/*
    File: fn_btree_enterNode_selector.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
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

#include "..\behaviour_trees.inc"

params ["_stackFrame"];

[[0], ACTION_RUN_CHILD]
