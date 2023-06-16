/*
    File: fn_skills_getTreeSkillPoints.sqf
    Author: Savage Game Design
    Date: 2023-05-13
    Last Update: 2023-06-16
    Public: No

    Description:
        Get amount of skill points player invested into the skilltree.

    Parameter(s):
        _skillTree - The skilltree to get the skill points from [STRING]
        _player - Player to check [OBJECT, defaults to player]

    Returns:
        Amount of skillpoints [NUMBER]

    Example(s):
        [_tree, player] call vgm_g_fnc_skills_getTreeSkillPoints;
 */

params ["_skillTree", ["_player", player]];

private _skillPoints = 0;
{
    private _skillTier = _x;
    {
        if ([_x, _player] call vgm_g_fnc_skills_isKnown) then {
            _skillPoints = _skillPoints + (_x get "cost");
        };
    } forEach _skillTier;
} forEach (_skillTree get "skills");

_skillPoints // return
