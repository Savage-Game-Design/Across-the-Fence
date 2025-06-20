/*
    File: fn_skill_actives_setCoefficientForDuration.sqf
    Author: Savage Game Design
    Date: 2025-06-18
    Last Update: 2025-06-18
    Public: No

    Description:
        Sets a coefficient for a period of time.

    Parameter(s):
        _player - Player [OBJECT]
        _skill - Skill being activated [HASHMAP]
        _coefficient - Name of the coefficient [STRING]
        _coefficientValue - Value to set [NUMBER]

    Returns:
        Nothing

    Example(s):
        codeActivate = "(_this + ["aim", -1]) call vgm_c_fnc_skill_active_setCoefficientForDuration
 */

params ["", "_skill", "_coefficient", "_coefficientValue"];

private _skillName = _skill get "path" select -1;

[
    format ["Skill %1 activated - Setting coefficient '%2' to %3", _skillName, _coefficient, _coefficientValue]
] call vgm_g_fnc_logInfo;

private _reason = str (_skill get "path");

[player, _coefficient, _reason, _coefficientValue] call vgm_c_fnc_coefficient_set;

[_skill, _skillName, _coefficient, _reason] spawn {
    params ["_skill", "_skillName", "_coefficient", "_reason"];
    sleep (_skill get "duration");
    [
        format ["Skill %1 exhausted - removing '%2' coefficient '%3'", _skillName, _coefficient, _reason]
    ] call vgm_g_fnc_logInfo;
    [player, _coefficient, _reason] call vgm_c_fnc_coefficient_remove;
};
