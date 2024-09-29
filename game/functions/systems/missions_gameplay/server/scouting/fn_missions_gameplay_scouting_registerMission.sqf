/*
    File: fn_missions_gameplay_scouting_registerMission.sqf
    Author: Savage Game Design
    Date: 2024-08-11
    Last Update: 2024-09-29
    Public: No

    Description:
        Register scouting data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_missions_gameplay_scouting_registerMission;
 */

params ["_missionId"];

private _scoutingNetmap = [_missionId, "scouting"] call vgm_s_fnc_missions_createSystemNetmap;

[_scoutingNetmap, "guessedSites", []] call para_s_fnc_netmap_set;
[_scoutingNetmap, "guessedSitesMax", 0] call para_s_fnc_netmap_set;
