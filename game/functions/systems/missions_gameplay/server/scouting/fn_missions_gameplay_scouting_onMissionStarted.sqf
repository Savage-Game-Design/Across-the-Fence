/*
    File: fn_missions_gameplay_scouting_onMissionStarted.sqf
    Author: Savage Game Design
    Date: 2024-09-29
    Last Update: 2024-09-29
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

[_data, "guessedSitesMax", count (_mission get "sites")] call para_s_fnc_netmap_set
