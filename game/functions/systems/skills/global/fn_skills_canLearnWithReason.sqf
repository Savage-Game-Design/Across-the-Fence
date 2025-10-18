/*
    File: fn_skills_canLearnWithReason.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2025-10-18
    Public: Yes

    Description:
        Check if player is eligible for learning given skill, and includes a reason if they can't.

    Parameter(s):
        _player - Player trying to learn the skill [OBJECT]
        _skill - Skill [HashMap]

    Returns:
        [
            Player can learn the skill [BOOL],
            Reason [STRING]
        ] [ARRAY]

    Example(s):
        [player, _skill] call vgm_g_fnc_skills_canLearnWithReason
 */

params [
    ["_player", objNull],
    ["_skill", createHashMap]
];

private _skillsData = _player getVariable ["vgm_g_skillsData", createHashMap];
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _unlockConditions = _skill getOrDefault ["conditionsUnlockGlobal", []];

private _hasEnoughSkillPoints = [
    {
        ((_skillsData getOrDefault ["skillPoints", 0]) >= (_skill get "cost"))
    },
    "STR_VGM_SKILLS_UI_NOT_ENOUGH_SKILLPOINTS"
];

private _isTierUnlocked = [
    {
        [_player, _skillTree, _skill get "tier"] call vgm_g_fnc_skills_tierUnlocked
    },
    "STR_VGM_SKILLS_UI_TIER_LOCKED"
];

// _skillTree and _skill should be considered as available for all conditions.
private _checks = _unlockConditions + [
    _isTierUnlocked,
    _hasEnoughSkillPoints
];

private _failedCheckIndex = _checks findIf { !([_player] call (_x # 0)) };

if (_failedCheckIndex > -1) exitWith {
    [false, _checks # _failedCheckIndex # 1]
};

[true, ""]


