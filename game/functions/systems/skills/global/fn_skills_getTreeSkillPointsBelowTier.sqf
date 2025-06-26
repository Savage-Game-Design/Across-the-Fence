/*
    File: fn_skills_getTreeSkillPointsBelowTier.sqf
    Author: Savage Game Design
    Date: 2023-05-13
    Last Update: 2025-06-26
    Public: No

    Description:
        Get amount of skill points player invested into the skilltree, below the given tier.

    Parameter(s):
        _skillTree - The skilltree to get the skill points from [STRING]
        _player - Player to check [OBJECT, defaults to player]
        _belowTier - Only include skills that are below this tier [NUMBER]

    Returns:
        Amount of skillpoints [NUMBER]

    Example(s):
        [_tree, player] call vgm_g_fnc_skills_getTreeSkillPointsBelowTier;
 */

params ["_skillTree", ["_player", player], ["_belowTier", 99999, [0]]];

private _skillPoints = 0;
{
    if (_forEachIndex >= _belowTier) exitWith {};
    private _skillTier = _x;
    {
        if ([_x, _player] call vgm_g_fnc_skills_isKnown) then {
            _skillPoints = _skillPoints + (_x get "cost");
        };
    } forEach _skillTier;
} forEach (_skillTree get "skills");

_skillPoints // return
