/*
    File: fn_skills_getTreeDiscounts.sqf
    Author: Savage Game Design
    Date: 2026-03-28
    Last Update: 2026-03-28
    Public: No

    Description:
        Returns all discounts applied to skill trees, as a hashmap.

    Parameter(s):
        _player - Player to get discounts for [UNIT]

    Returns:
        A map from skill tree names to the discount factor [HASHMAP]

    Example(s):
        [player] call vgm_g_fnc_skills_getTreeDiscounts;
 */

params ["_player"];


_player getVariable ["vgm_g_skills_treeDiscounts", createHashMap];
