/*
    File: fn_btree_setTreeByNameGlobal.sqf
    Author: Savage Game Design
    Date: 2024-04-03
    Last Update: 2024-05-03
    Public: Yes

    Description:
        Sets a group's behaviour tree to the compiled tree referred to by "name", regardless of group's locality.

        Makes the group's behaviour tree persist on locality change, if _persistOnLocalityChange is set (which it is by default)

    Parameter(s):
        _group - Group to set the tree on [GROUP]
        _name - Name of the compiled tree to use [STRING]
        _persistOnLocalityChange - When the owner of the group changes, should this tree start running on the new owner? [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [allGroups # 0, "enemyAI"] call vgm_g_fnc_btree_setTreeByNameGlobally;
 */

params ["_group", "_name", ["_persistOnLocalityChange", true]];

[_group, _name] remoteExecCall ["vgm_g_fnc_btree_setTreeByNameLocal", groupOwner _group];

if (_persistOnLocalityChange) then {
    _group setVariable ["btree_g_globalTreeName", _name, true];
};
