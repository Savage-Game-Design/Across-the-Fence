/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2025-06-29
    Public: No

    Description:
        Get player skill data from local cache.

    Parameter(s):
        _player - Player to get the skill data for [OBJECT]

    Returns:
        Player skills data [HASHMAP]

    Example(s):
        _player call vgm_s_fnc_skills_dataGetCached
 */

params ["_player"];

private _hashMap = _player getVariable "vgm_g_skillsData";
if (isNil "_hashMap") then {
    format ["Skills cached data is nil: %1", _player] call vgm_g_fnc_logError;
};

_hashMap // return
