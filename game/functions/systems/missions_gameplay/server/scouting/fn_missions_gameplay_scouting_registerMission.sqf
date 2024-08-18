/*
    File: fn_missions_gameplay_scouting_registerMission.sqf
    Author: Savage Game Design
    Date: 2024-08-11
    Last Update: 2024-08-18
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
[_scoutingNetmap, "objects", createHashMap] call para_s_fnc_netmap_set;
