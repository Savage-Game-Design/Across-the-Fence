/*
    File: fn_btree_getCompiledTree.sqf
    Author:
    Date: 2024-02-10
    Last Update: 2024-02-10
    Public: No

    Description:
        Gets a pre-compiled behaviour tree.

    Parameter(s):
        _treeName - Name of the tree to fetch [STRING]

    Returns:
        Compiled behaviour tree [HASHMAP]

    Example(s):
        ["enemyAI"] call vgm_g_fnc_btree_tree_getCompiledTree;
 */

params ["_treeName"];

vgm_l_btree_compiledTrees get _treeName
