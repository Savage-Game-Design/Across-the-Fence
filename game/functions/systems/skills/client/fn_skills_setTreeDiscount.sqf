/*
    File: fn_skills_setTreeDiscount.sqf
    Author: Savage Game Design
    Date: 2026-03-28
    Last Update: 2026-03-28
    Public: No

    Description:
        Sets a discount on the number of points each skill in a tree costs.

    Parameter(s):
        _treeName - Tree to discount. This is index 0 of a skill's path [STRING]
        _discount - Amount to discount by. [NUMBER]

    Returns:
        Nothing

    Example(s):
        ["medic", 0.5] call vgm_c_fnc_skills_setTreeDiscount;
 */

params ["_treeName", ["_factor", 0.5]];

private _discounts = player getVariable ["vgm_g_skills_treeDiscounts", createHashMap];

_discounts set [_treeName, _factor];

player setVariable ["vgm_g_skills_treeDiscounts", _discounts, true];
