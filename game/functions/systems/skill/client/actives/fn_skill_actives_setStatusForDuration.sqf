/*
    File: fn_skill_actives_setStatusForDuration.sqf
    Author: Savage Game Design
    Date: 2025-06-18
    Last Update: 2025-06-18
    Public: No

    Description:
        Sets a status effect for a period of time.

    Parameter(s):
        _player - Player [OBJECT]
        _skill - Skill being activated [HASHMAP]
        _effect - Name of the status effect [STRING]

    Returns:
        Nothing

    Example(s):
        codeActivate = "(_this + ["forceWalk"]) call vgm_c_fnc_skill_active_setStatusForDuration
 */

params ["", "_skill", "_effect"];

private _skillName = _skill get "path" select -1;

[
    format ["Skill %1 activated - Enabling status effect '%2'", _skillName, _effect]
] call vgm_g_fnc_logInfo;

private _reason = str (_skill get "path");

[player, _effect, _reason] call vgm_c_fnc_statusEffect_set;

[_skill, _skillName, _effect, _reason] spawn {
    params ["_skill", "_skillName", "_effect", "_reason"];
    sleep (_skill get "duration");
    [
        format ["Skill %1 exhausted - disabling status effect '%2'", _skillName, _effect]
    ] call vgm_g_fnc_logInfo;
    [player, _effect, _reason] call vgm_c_fnc_statusEffect_remove;
};
