/*
    File: fn_skills_dbGet.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        Get player skill data from DB or local cache.

    Parameter(s):
        _player - Player to get the skill data for [OBJECT]

    Returns:
        Something [BOOL]

    Example(s):
        _player call vgm_s_fnc_skills_dbGet
 */

params ["_player"];

private _hash = _player getVariable "vgm_g_skillsData";
if (isNil "_hash") then {
    _hash = ["player_skills", getPlayerUID _player] call vgm_s_fnc_db_get;
    _player setVariable ["vgm_g_skillsData", _hash];
};

_hash getOrDefault ["skillPoints" , 0, true];
_hash getOrDefault ["skillPaths" , [], true];

_hash // return
