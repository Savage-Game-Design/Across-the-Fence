/*
    File: fn_missions_updateStatus.sqf
    Author:
    Date: 2023-02-26
    Last Update: 2023-09-20
    Public: No

    Description:
        Updates the status of a mission

    Parameter(s):
        _mission - Mission to update the status on [HASHMAP]
        _status - Status to change to. One of CREATED, DEPLOYING, IN_PROGRESS [STRING]

    Returns:
        Nothing

    Example(s):
        [32, "DEPLOYING"] call vgm_s_fnc_missions_updateStatus
 */

params ["_mission", "_status"];

if !(_status in ["CREATED", "IN PROGRESS", "FINISHED"]) exitWith {
    ["ERROR", format ["Cannot set status of mission %1 to invalid status %2", _mission get "public" get "id", _status]] call para_g_fnc_log;
};

[_mission get "public", "status", _status] call para_s_fnc_netmap_set;

[
    "vgm_mission_status_changed",
    [_mission get "public" get "id", _status]
] call para_g_fnc_event_triggerLocal;

