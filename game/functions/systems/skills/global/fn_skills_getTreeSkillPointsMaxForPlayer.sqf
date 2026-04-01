/*
    File: fn_skills_getTreeSkillPointsMaxForPlayer.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: Yes

    Description:
        Get the maximum skill points for a skill tree, accounting for player-specific discounts.

    Parameter(s):
        _skillTree - The skilltree [HASHMAP]
        _player - Player to check [OBJECT, defaults to player]

    Returns:
        Maximum skill points [NUMBER]

    Example(s):
        [_skillTree, player] call vgm_g_fnc_skills_getTreeSkillPointsMaxForPlayer;
 */

params ["_skillTree", ["_player", player]];

private _max = 0;
{
    {
        _max = _max + ([_x, _player] call vgm_g_fnc_skills_getSkillCostForPlayer);
    } forEach _x;
} forEach (_skillTree get "skills");

_max
