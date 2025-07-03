/*
    File: fn_skills_canLearn.sqf
    Author: veteran29
    Date: 2022-12-22
    Last Update: 2025-07-03
    Public: Yes

    Description:
        Check if player is eligible for learning given skill.

    Parameter(s):
        _player - Player trying to learn the skill [OBJECT]
        _skill - Skill [HashMap]

    Returns:
        Player can learn the skill [BOOL]

    Example(s):
        [player, _skill] call vgm_g_fnc_skills_canLearn
 */

_this call vgm_g_fnc_skills_canLearnWithReason select 0
