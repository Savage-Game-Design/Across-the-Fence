/*
    File: fn_btree_preInit.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        Preinit for behaviour trees.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#include "..\behaviour_trees.inc"

// Use hashmap lookups for handlers, as it's slightly safer than 'format'ing a function name and calling it.
localNamespace setVariable ["vgm_l_btree_enterNodeHandlers", createHashMapFromArray [
    [NODE_TYPE_ACTION, vgm_g_fnc_btree_enterNode_action],
    [NODE_TYPE_DECORATOR, vgm_g_fnc_btree_enterNode_decorator],
    [NODE_TYPE_SEQUENCE, vgm_g_fnc_btree_enterNode_sequence],
    [NODE_TYPE_SELECTOR, vgm_g_fnc_btree_enterNode_selector]
]];

localNamespace setVariable ["vgm_l_btree_runCurrentNodeHandlers", createHashMapFromArray [
    [NODE_TYPE_ACTION, vgm_g_fnc_btree_runCurrentNode_action],
    [NODE_TYPE_DECORATOR, vgm_g_fnc_btree_runCurrentNode_decorator],
    [NODE_TYPE_SEQUENCE, vgm_g_fnc_btree_runCurrentNode_sequence],
    [NODE_TYPE_SELECTOR, vgm_g_fnc_btree_runCurrentNode_selector]
]];

localNamespace setVariable ["vgm_l_btree_exitNodeHandlers", createHashMapFromArray [
    [NODE_TYPE_ACTION, vgm_g_fnc_btree_exitNode_action],
    [NODE_TYPE_DECORATOR, vgm_g_fnc_btree_exitNode_decorator],
    [NODE_TYPE_SEQUENCE, vgm_g_fnc_btree_exitNode_sequence],
    [NODE_TYPE_SELECTOR, vgm_g_fnc_btree_exitNode_selector]
]];

localNamespace setVariable ["vgm_l_btree_childFinishedHandlers", createHashMapFromArray [
    [NODE_TYPE_ACTION, vgm_g_fnc_btree_childFinished_action],
    [NODE_TYPE_DECORATOR, vgm_g_fnc_btree_childFinished_decorator],
    [NODE_TYPE_SEQUENCE, vgm_g_fnc_btree_childFinished_sequence],
    [NODE_TYPE_SELECTOR, vgm_g_fnc_btree_childFinished_selector]
]];

localNamespace setVariable ["vgm_l_btree_abortHandlers", createHashMapFromArray [
    [NODE_TYPE_ACTION, vgm_g_fnc_btree_abort_action],
    [NODE_TYPE_DECORATOR, vgm_g_fnc_btree_abort_decorator],
    [NODE_TYPE_SEQUENCE, vgm_g_fnc_btree_abort_sequence],
    [NODE_TYPE_SELECTOR, vgm_g_fnc_btree_abort_selector]
]];
