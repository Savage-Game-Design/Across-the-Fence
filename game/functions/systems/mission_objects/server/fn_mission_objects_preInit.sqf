/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-12-18
    Last Update: 2023-12-20
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

vgm_s_mission_objects_data = createHashMap;

["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    private _missionObjects = vgm_s_mission_objects_data getOrDefault [_missionId, createHashMap];

    format ["Sending server objects for: %1", _missionId] call vgm_g_fnc_logInfo;
    [_missionObjects] remoteExecCall ["vgm_c_fnc_mission_objects_spawnObjects", values (_mission get "machineIds")];
}] call para_g_fnc_event_subscribeLocal;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    format ["Removing server objects for: %1", _missionId] call vgm_g_fnc_logInfo;
    vgm_s_mission_objects_data deleteAt _missionId;
}] call para_g_fnc_event_subscribeLocal;
