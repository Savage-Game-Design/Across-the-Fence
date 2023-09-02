/*
    File: fn_skills_tierUnlocked.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: Yes

    Description:
        Check if player can access specified tier of given skilltree.

    Parameter(s):
        _player - Player to check [OBJECT]
        _skillTree - Skill tree [HashMap]
        _tier - Tier being checked [HashMap]

    Returns:
        Skilltree tier is unlocked [BOOL]

    Example(s):
        [player, ["combatTree"] call vgm_g_fnc_skills_getByPath, 0] call vgm_g_fnc_skills_tierUnlocked
 */

params [
    ["_player", objNull],
    ["_skillTree", createHashMap],
    ["_tier", -1, [0]]
];

if (_tier < 1) exitWith {
    private _path = _skillTree get "path";

    // root level skill tree is always unlocked
    if (count _path <= 1) exitWith {true};

    // check if last tier of previous tree is unlocked
    _path = _path select [0, count _path - 1];
    private _parentSkillTree = _path call vgm_g_fnc_skills_getByPath;
    private _tiersCount = count (_parentSkillTree get "skills");

    // check if last tier of previous tree is unlocked
    private _lastTierPrevTree = _tiersCount - 1;
    [_player, _parentSkillTree, _lastTierPrevTree] call vgm_g_fnc_skills_tierInvested // return
};

[_player, _skillTree, _tier - 1] call vgm_g_fnc_skills_tierInvested // return
