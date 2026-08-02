/*
    File: fn_missions_gameplay_bright_light_registerMission.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Register Bright Light Rescue data in mission data.

    Parameter(s):
        _missionId - Mission id [NUMBER]

    Returns:
        Nothing

    Example(s):
        _missionId call vgm_s_fnc_missions_gameplay_bright_light_registerMission;
 */

params ["_missionId"];

private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_createSystemNetmap;

// Bright Light is always a downed pilot rescue
private _rescueType = "downed_pilot";

[_blNetmap, "rescueType", _rescueType] call para_s_fnc_netmap_set;
[_blNetmap, "targetFound", false] call para_s_fnc_netmap_set;
[_blNetmap, "targetRescued", false] call para_s_fnc_netmap_set;
[_blNetmap, "targetExtracted", false] call para_s_fnc_netmap_set;
[_blNetmap, "target", objNull] call para_s_fnc_netmap_set;
[_blNetmap, "spawnedUnits", []] call para_s_fnc_netmap_set;
[_blNetmap, "wreck", objNull] call para_s_fnc_netmap_set;

// Downed pilot variant keys
[_blNetmap, "pilotVariant", ""] call para_s_fnc_netmap_set;
[_blNetmap, "crashPos", [0,0,0]] call para_s_fnc_netmap_set;
[_blNetmap, "sitePos", [0,0,0]] call para_s_fnc_netmap_set;
[_blNetmap, "intelGathered", false] call para_s_fnc_netmap_set;
[_blNetmap, "assaultTriggered", false] call para_s_fnc_netmap_set;
[_blNetmap, "sceneObjects", []] call para_s_fnc_netmap_set;
[_blNetmap, "hiddenTerrainObjects", []] call para_s_fnc_netmap_set;
[_blNetmap, "missionDeadline", 0] call para_s_fnc_netmap_set;
