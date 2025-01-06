/*
    File: fn_sites_hints_registerMission.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2024-12-16
    Public: No

    Description:
        Register hints data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_sites_hints_registerMission;
 */

params ["_missionId"];

private _hintsNetmap = [_missionId, "sites_hints"] call vgm_s_fnc_missions_createSystemNetmap;

[_hintsNetmap, "inspectedHints", [] call para_s_fnc_netmap_createNetmap] call para_s_fnc_netmap_set;
