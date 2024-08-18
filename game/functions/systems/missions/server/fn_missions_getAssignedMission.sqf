/*
    File: fn_missions_getAssignedMission.sqf
    Author: Savage Game Design
    Date: 2023-09-29
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Gets the mission the player is currently assigned to.

    Parameter(s):
        _playerId - ID of the player

    Returns:
        Mission the player is assigned to [HashMap]

    Example(s):
        [getPlayerID (allPlayers # 0)] call vgm_s_fnc_missions_getAssignedMission;
 */

params ["_playerId"];

private _missionId = (["vgm_mission_assignments"] call para_g_fnc_netmap_get) getOrDefault [_playerId, -1];

[_missionId] call vgm_s_fnc_missions_getById // return
