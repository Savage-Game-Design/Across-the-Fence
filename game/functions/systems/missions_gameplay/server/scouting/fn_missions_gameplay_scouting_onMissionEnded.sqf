/*
    File: fn_missions_gameplay_scouting_onMissionEnded.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2024-12-06
    Public: No

    Description:
        Handle mission end.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_scouting_onMissionEnded
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    format ["Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

// Cleanup officer if spawned
private _scoutingData = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
if (!isNil "_scoutingData") then {
    private _officer = _scoutingData get "officer";
    if (!isNil "_officer" && { !isNull _officer }) then {
        deleteVehicle _officer;
    };
    private _officerGroup = _scoutingData get "officerGroup";
    if (!isNil "_officerGroup" && { !isNull _officerGroup }) then {
        { deleteVehicle _x } forEach units _officerGroup;
    };
};

[
    format ["vgm_scout_%1", _mission get "public" get "id"],
    true,
    true
] call BIS_fnc_deleteTask;
