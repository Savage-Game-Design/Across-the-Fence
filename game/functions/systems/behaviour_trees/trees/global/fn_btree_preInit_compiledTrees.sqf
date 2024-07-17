/*
    File: fn_btree_tree_preInit.sqf
    Author: Savage Game Design
    Date: 2024-02-10
    Last Update: 2024-05-03
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

private _fnc_setupGroup = {
    params ["_group"];

    // Re-apply the group's global behaviour tree, if this client becomes their owner
    _group addEventHandler ["Local", {
        params ["_group", "_local"];

        if !(_local) exitWith {};

        [_group] call vgm_g_fnc_btree_setTreeByNameFromGroupGlobalVar;
    }];

    // Unlikely to ever be called, but covers an edge case.
    if (local _x) then {
        [_x] call vgm_g_fnc_btree_setTreeByNameFromGroupGlobalVar;
    };
};

addMissionEventHandler ["GroupCreated", _fnc_setupGroup];

{
    [_x] call _fnc_setupGroup;
} forEach allGroups;



