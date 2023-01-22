/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-01-22
    Public: No

    Description:
        Server preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

// TODO, placeholder until event system is in place
vgm_s_fnc_skills_loadPlayerSkills = {
    params ["_player"];

    ["DEBUG", format ["VGM: Loading skills data for %1 (%2)", name _player, getPlayeRUID _player]] call para_g_fnc_log;

    [_player call vgm_s_fnc_skills_dbGet] remoteExecCall ["vgm_c_fnc_skills_loadSkillsData", _player];
};

vgm_s_fnc_skills_handleLearnRequest = {
    params ["_player", "_skillPath"];

    // TODO server side validation? event based?

    ["DEBUG", format ["VGM: Handling learn request for %1 (%2)", name _player, getPlayeRUID _player]] call para_g_fnc_log;

    private _playerSkills = _player call vgm_s_fnc_skills_dbGet;
    _playerSkills get "skillPaths" pushBackUnique _skillPath;

    [_player, _playerSkills] call vgm_s_fnc_skills_dbSave;
    // let the client know that server ackowledged the learning
    player setVariable ["vgm_c_skills_learnRequestResult", true, owner _player];
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
