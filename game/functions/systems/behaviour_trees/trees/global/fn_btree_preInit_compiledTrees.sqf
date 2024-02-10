/*
    File: fn_btree_tree_preInit.sqf
    Author: Savage Game Design
    Date: 2024-02-10
    Last Update: 2024-02-10
    Public: No

    Description:
        Pre-init for behaviour trees.

        Pre-compiles certain trees to make them available on all machines.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        N/A
 */

vgm_l_btree_compiledTrees = createHashMapFromArray [
    ["enemyAI", [[] call vgm_g_fnc_btree_tree_enemyAI] call vgm_g_fnc_btree_compileTree]
];
