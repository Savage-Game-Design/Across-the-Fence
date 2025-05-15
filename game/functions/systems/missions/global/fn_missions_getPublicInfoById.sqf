/*
    File: fn_missions_getPublicInfoById.sqf
    Author: Savage Game Design
    Date: 2025-04-04
    Last Update: 2025-04-04
    Public: Yes

    Description:
        Get public mission info by its ID.

    Parameter(s):
        _missionId - Mission ID [NUMBER]

    Returns:
        Mission or nil [HASHMAP]

    Example(s):
        [2] call vgm_g_fnc_missions_getPublicInfoById
 */

params [["_missionId", -1, [0]]];

private _missions = ["vgm_missions_publicMissionInfo", createHashMap] call para_g_fnc_netmap_getOrDefault;

_missions get _missionId
