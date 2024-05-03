/*
    File: fn_btree_setTreeByNameFromGroupGlobalVar.sqf
    Author: Savage Game Design
    Date: 2024-05-03
    Last Update: 2024-05-03
    Public: No

    Description:
        Sets the group's behaviour tree to the one named in the group's global tree variable.

        The main use is on locality change to re-apply the tree.

    Parameter(s):
        _group - Group to set the tree on [GROUP]

    Returns:
        Nothing

    Example(s):
        {
            if (local _x) then {
                [_x] call vgm_g_fnc_btree_setTreeFromGroupGlobalValue;
            };
        } forEach allGroups;
 */

params ["_group"];

private _globalTreeName = _group getVariable "btree_g_globalTreeName";

if (isNil "_globalTreeName") exitWith {};

[_group, _globalTreeName] call vgm_g_fnc_btree_setTreeByNameLocal;


