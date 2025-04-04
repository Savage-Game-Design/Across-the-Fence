/*
    File: fn_missions_getCurrentMission.sqf
    Author: Savage Game Design
    Date: 2023-04-24
    Last Update: 2025-04-04
    Public: Yes

    Description:
        Retrieves the "public" data of current mission the player is assigned to.

    Parameter(s):
        None

    Returns:
        Mission [HASHMAP]

    Example(s):
        [] call vgm_c_fnc_missions_getCurrentMission;
 */

private _assignments = ["vgm_mission_assignments", createHashMap] call para_g_fnc_netmap_getOrDefault;

[_assignments get (getPlayerID player)] call vgm_g_fnc_missions_getPublicInfoById
