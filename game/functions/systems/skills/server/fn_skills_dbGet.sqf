/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-02-24
    Public: No

    Description:
        Get player skill data from DB or local cache.

    Parameter(s):
        _player - Player to get the skill data for [OBJECT]

    Returns:
        Player skills data [HASHMAP]

    Example(s):
        _player call vgm_s_fnc_skills_dbGet
 */

params ["_player"];

private _hashMap = _player getVariable "vgm_g_skillsData";
if (isNil "_hashMap") then {
    _hashMap = ["player_skills", getPlayerUID _player] call vgm_s_fnc_db_get;
    _player setVariable ["vgm_g_skillsData", _hashMap];
};

_hashMap set ["skillPoints" , 0, true];
_hashMap set ["skillPaths" , [], true];

_hashMap // return
