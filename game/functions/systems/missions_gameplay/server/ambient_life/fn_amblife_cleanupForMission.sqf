/*
    File: fn_amblife_cleanupForMission.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Cleans up all ambient life entities for a given mission.
        Deletes animals (createAgent), checkpoint barrier objects, and stops the
        civilian reporting monitor. Virtual squads are auto-cleaned by the mission system.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0] call vgm_s_fnc_amblife_cleanupForMission;
 */

params ["_missionId"];

// Stop the civilian reporting loop and respawn monitor
vgm_s_amblife_missionActive set [_missionId, false];

// Terminate respawn monitor script
private _respawnHandle = vgm_s_amblife_missionRespawnHandles getOrDefault [_missionId, scriptNull];
if (!isNull _respawnHandle) then {
    terminate _respawnHandle;
};
vgm_s_amblife_missionRespawnHandles deleteAt _missionId;

// Delete all animal agents
private _animals = vgm_s_amblife_missionAnimals getOrDefault [_missionId, []];
{
    deleteVehicle _x;
} forEach _animals;
vgm_s_amblife_missionAnimals deleteAt _missionId;

// Delete all checkpoint barrier objects
private _objects = vgm_s_amblife_missionObjects getOrDefault [_missionId, []];
{
    deleteVehicle _x;
} forEach _objects;
vgm_s_amblife_missionObjects deleteAt _missionId;

format ["[AmbLife] Cleaned up ambient life for mission %1", _missionId] call vgm_g_fnc_logInfo;
