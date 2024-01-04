/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-12-18
    Last Update: 2024-01-04
    Public: No

    Description:
        Client preInit for mission_objects component.
 */

vgm_g_mission_objects = createHashMap;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    private _localObjectsData = vgm_g_mission_objects getOrDefault [_missionId, createHashMap];

    format ["Removing all local objects for: %1", _missionId] call vgm_g_fnc_logInfo;

    {
        deleteVehicle _y;
        _localObjectsData deleteAt _x;
    } forEach _localObjectsData;
    vgm_g_mission_objects deleteAt _missionId;
}] call para_g_fnc_event_subscribeServer;
