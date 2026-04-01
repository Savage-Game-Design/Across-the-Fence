/*
    File: fn_skills_getSkillCostForPlayer.sqf
    Author: Savage Game Design
    Date: 2026-03-28
    Last Update: 2026-03-28
    Public: Yes

    Description:
        Gets the points cost of a skill for a particular player, applying any player-specific modifiers.

    Parameter(s):
        _skill - Skill [HASHMAP]
        _player - Player to check [UNIT]

    Returns:
        Points cost [NUMBER]

    Example(s):
        [[_path] call vgm_g_fnc_skills_getByPath, player] call vgm_g_fnc_skills_getSkillCostForPlayer;
 */

params ["_skill", ["_player", player]];

private _treeId = _skill get "path" select 0;
private _discount = [_player] call vgm_g_fnc_skills_getTreeDiscounts;

ceil ((_skill get "cost") * (_discount getOrDefault [_treeId, 1]))
