/*
    File: fn_btree_setTreeByName.sqf
    Author: Savage Game Design
    Date: 2024-04-03
    Last Update: 2024-04-03
    Public: No

    Description:
        Sets a group's behaviour tree to the compiled tree referred to by "name".

        Useful for remoteExec'ing setTree without sending a tree over the network.

    Parameter(s):
        _group - Group to set the tree on [GROUP]
        _name - Name of the compiled tree to use [STRING]

    Returns:
        Nothing

    Example(s):
        [allGroups # 0, "enemyAI"] call vgm_g_fnc_btree_setTreeByName;
 */

params ["_group", "_name"];

[_group, [_name] call vgm_g_fnc_btree_getCompiledTree] call vgm_g_fnc_btree_setTree;
