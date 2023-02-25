/*
    File: fn_missions_getCurrentMission.sqf
    Author: Savage Game Design
    Date: 2023-04-24
    Last Update: 2023-04-24
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

private _missionsData = localNamespace getVariable "vgm_c_missions_data";

_missionsData get "missions" get (_missionsData get "currentMission")
