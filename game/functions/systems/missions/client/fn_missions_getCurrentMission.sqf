/*
    File: fn_missions_getCurrentMission.sqf
    Author: Savage Game Design
    Date: 2023-04-24
    Last Update: 2023-06-23
    Public: Yes

    Description:
        Retrieves the current mission the player is assigned to

    Parameter(s):
        None

    Returns:
        Mission [HASHMAP]

    Example(s):
        [] call vgm_c_fnc_missions_getCurrentMission;
 */

private _assignments = ["vgm_mission_assignments", createHashMap] call para_g_fnc_netmap_getOrDefault;
private _missions = ["vgm_missions_publicMissionInfo", createHashMap] call para_g_fnc_netmap_getOrDefault;


_missions get (_assignments get (getPlayerID player))
