/*
    File: fn_btree_runCurrentNode.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#include "..\behaviour_trees.inc"

params ["_stackItem"];

// Bad case, shouldn't happen.
["Cannot run current node - Sequence nodes should never be current"] call vgm_g_fnc_btree_log;

// Return to parent, to try and recover.
[[], ACTION_RETURN_TO_PARENT]
