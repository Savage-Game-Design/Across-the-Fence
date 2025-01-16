#include "script_component.inc"
/*
    File: fn_virtsquad_getMissionSquadsInfo.sqf
    Author: Savage Game Design
    Date: 2025-01-16
    Last Update: 2025-01-16
    Public: No

    Description:
        Gets the information on squads on a specific mission.

        If the mission doesn't exist, or missionId is nil, returns the global squad info hashmap.

    Parameter(s):
        _missionId - ID of the mission to get squad info for [STRING]

    Returns:
        Squad info [HASHMAP]

    Example(s):
        [[_playerId] call vgm_s_fnc_missions_getAssignedMissionId] call vgm_s_fnc_virtsquad_getMissionSquadsInfo
 */

params ["_missionId"];

// With the various loops that monitor spawning, it's possible to be trying to get info on a mission which hasn't been
// instantiated yet. Until that's ready, we use the global mission info to ensure there's always a valid object.
// It also enables us to have squads that exist outside of missions.
private _missionIdToUse = [GLOBAL_MISSION_ID, _missionId] select (_missionId in vgm_s_virtsquad_perMissionSquadsInfo);

vgm_s_virtsquad_perMissionSquadsInfo get _missionIdToUse
