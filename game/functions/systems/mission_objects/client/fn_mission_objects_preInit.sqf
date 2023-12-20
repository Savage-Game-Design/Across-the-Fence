/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-12-18
    Last Update: 2023-12-20
    Public: No

    Description:
        Client preInit for mission_objects component.
 */

vgm_c_mission_objects = createHashMap;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    private _currentMissionId = [] call vgm_c_fnc_missions_getCurrentMission get "id";
    if (isNil "_currentMissionId" || {_missionId != _currentMissionId}) exitWith {};

    format ["Removing all local objects for: %1", _missionId] call vgm_g_fnc_logInfo;

    {
        deleteVehicle _y;
        vgm_c_mission_objects deleteAt _x;
    } forEach vgm_c_mission_objects;
}] call para_g_fnc_event_subscribeServer;
