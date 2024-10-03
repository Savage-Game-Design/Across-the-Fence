/*
    File: fn_missions_gameplay_scouting_onMissionStarted.sqf
    Author: Savage Game Design
    Date: 2024-09-29
    Last Update: 2024-10-03
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        _missionId -

    Returns:
        Something [BOOL]

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_scouting_onMissionStarted
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    format ["Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _data = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

[_data, "guessedSitesMax", count (_mission get "sites")] call para_s_fnc_netmap_set;

// add task for the players
[_mission] spawn {
    params ["_mission"];
    sleep 10;

    private _playerGroup = _mission get "public" get "group";
    private _sites = +(_mission get "sites");

    private _intelSites = [];
    for "_" from 1 to (2 + floor random 4) do {
        _intelSites pushBack selectRandom _sites;
        _sites = _sites - _intelSites;
    };

    _intelSites = _intelSites apply {format [
        "<execute expression='%2'>%1</execute>",
        ((_x get "pos") call BIS_fnc_posToGrid) joinString " ",
        format ["[[750,750], %1] call BIS_fnc_zoomOnArea", _x get "pos"]
    ]} joinString "<br/>";

    [
        _playerGroup,
        format ["vgm_scout_%1", _mission get "id"],
        [
            ["STR_VGM_MISSIONS_SCOUTING_TASK_DESCRIPTION", _intelSites],
            "STR_VGM_MISSIONS_SCOUTING_TASK_TITLE"
        ],
        objNull,
        "ASSIGNED",
        -1,
        true,
        "scout"
    ] call BIS_fnc_taskCreate;
};
