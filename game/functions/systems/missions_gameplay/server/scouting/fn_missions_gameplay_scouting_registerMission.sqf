/*
    File: fn_missions_gameplay_scouting_registerMission.sqf
    Author: Savage Game Design
    Date: 2024-08-11
    Last Update: 2024-08-17
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

private _spottingNetmap = [_missionId, "spotting"] call vgm_s_fnc_missions_createSystemNetmap;
[_spottingNetmap, "objects", []] call para_s_fnc_netmap_set;
