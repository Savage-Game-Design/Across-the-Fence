/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-02-25
    Public: No

    Description:
        Server preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

vgm_s_skills_playerSkillsDataCache = createHashMap;

addMissionEventHandler ["PlayerConnected", {
    params ["", "_uid"];

    private _playerSkillsData = ["player_skills", _uid] call vgm_s_fnc_db_get;
    _playerSkillsData set ["skillPoints" , 0, true];
    _playerSkillsData set ["skillPaths" , [], true];

    vgm_s_skills_playerSkillsDataCache set [_uid, _playerSkillsData];
}];

addMissionEventHandler ["PlayerDisconnected", {
    params ["", "_uid"];

    vgm_s_skills_playerSkillsDataCache deleteAt _uid;
}];
