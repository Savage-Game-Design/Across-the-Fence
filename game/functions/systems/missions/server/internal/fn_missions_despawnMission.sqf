/*
    File: fn_missions_despawnMission.sqf
    Author:
    Date: 2023-09-08
    Last Update: 2023-09-08
    Public: No

    Description:
        Cleans up entities in the mission. Units, locations, scripts, etc.

    Parameter(s):
        _mission - Mission to cleanup [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_currentMission] call vgm_s_fnc_missions_despawnMission;
 */

params ["_mission"];

terminate (_mission get "overlord_fsm");
