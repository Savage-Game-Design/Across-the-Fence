/*
    File: fn_missions_gameplay_snatch_registerMission.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Register Prisoner Snatch data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_missions_gameplay_snatch_registerMission;
 */

params ["_missionId"];

private _snatchNetmap = [_missionId, "snatch"] call vgm_s_fnc_missions_createSystemNetmap;

[_snatchNetmap, "targetStatus", "alive"] call para_s_fnc_netmap_set;
[_snatchNetmap, "targetCaptured", false] call para_s_fnc_netmap_set;
[_snatchNetmap, "targetExtracted", false] call para_s_fnc_netmap_set;
[_snatchNetmap, "officer", objNull] call para_s_fnc_netmap_set;
[_snatchNetmap, "guards", []] call para_s_fnc_netmap_set;
