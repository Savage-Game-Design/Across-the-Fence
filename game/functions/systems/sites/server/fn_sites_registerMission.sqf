/*
    File: fn_sites_registerMission.sqf
    Author: Savage Game Design
    Date: 2025-01-14
    Last Update: 2025-01-15
    Public: No

    Description:
        Register sites data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_sites_registerMission
 */

params ["_missionId"];

private _scoutingNetmap = [_missionId, "sites"] call vgm_s_fnc_missions_createSystemNetmap;

[_scoutingNetmap, "sites", [] call para_s_fnc_netmap_createNetmap] call para_s_fnc_netmap_set;
