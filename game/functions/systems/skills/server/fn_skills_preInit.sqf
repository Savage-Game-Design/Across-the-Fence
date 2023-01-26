/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-01-26
    Public: No

    Description:
        Server preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

[[0], "vgm_skills_requestData", {
    params ["_player"];
    ["DEBUG", format ["VGM: Received player skills load request %1 (%2)", name _player, getPlayeRUID _player]] call para_g_fnc_log;

    private _skills = _player call vgm_s_fnc_skills_dbGet;
    [["vgm_skills_loadData", _player], _skills] call para_g_fnc_event_trigger;
}] call para_g_fnc_event_subscribe;

vgm_s_fnc_skills_handleLearnRequest = {
    params ["_player", "_skillPath"];

    // TODO server side validation?
    private _result = true;

    ["DEBUG", format ["VGM: Handling learn request for %1 (%2)", name _player, getPlayeRUID _player]] call para_g_fnc_log;

    private _playerSkills = _player call vgm_s_fnc_skills_dbGet;
    _playerSkills get "skillPaths" pushBackUnique _skillPath;

    [_player, _playerSkills] call vgm_s_fnc_skills_dbSave;
    // let the client know that server ackowledged the learning

    [["vgm_skills_learnResponse", _player], _result] call para_g_fnc_event_trigger;
};

vgm_s_fnc_skills_dbGet = {
    params ["_player"];
    private _hash = ["player_skills", getPlayerUID _player] call vgm_s_fnc_db_get;

    _hash getOrDefault ["skillPoints" , 0, true];
    _hash getOrDefault ["skillPaths" , [], true];

    _hash // return
};

vgm_s_fnc_skills_dbSave = {
    params ["_player", "_hash"];

    ["player_skills", getPlayerUID _player, _hash] call vgm_s_fnc_db_typed_save;
    saveMissionProfileNamespace;
};

// ["vgm_player_init", ] call para_g_fnc_event_subscribe;
