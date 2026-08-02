/*
    File: fn_missions_gameplay_hatchet_registerMission.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Register Hatchet Force data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_missions_gameplay_hatchet_registerMission;
 */

params ["_missionId"];

private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_createSystemNetmap;

private _insertionType = selectRandom ["hot", "cold"];

[_hatchetNetmap, "insertionType", _insertionType] call para_s_fnc_netmap_set;
[_hatchetNetmap, "reconTeamAlive", 3] call para_s_fnc_netmap_set;
[_hatchetNetmap, "reconTeamRescued", 0] call para_s_fnc_netmap_set;
[_hatchetNetmap, "reconTeam", []] call para_s_fnc_netmap_set;
[_hatchetNetmap, "spawnedEnemies", []] call para_s_fnc_netmap_set;
[_hatchetNetmap, "phase", "invulnerable"] call para_s_fnc_netmap_set;
