/*
    File: fn_btree_runCurrentNode_selector.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Runs the current node (i.e the node on the topmost stack frame).

        Only triggered when that node is of type "selector".

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

// Bad case, shouldn't happen.
["Cannot run current node - Selector nodes should never be current"] call vgm_g_fnc_btree_log;

// Return to parent, to try and recover.
[[], ACTION_RETURN_TO_PARENT]
