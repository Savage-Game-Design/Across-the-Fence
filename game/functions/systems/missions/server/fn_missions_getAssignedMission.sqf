/*
    File: fn_missions_getAssignedMission.sqf
    Author: Savage Game Design
    Date: 2023-09-29
    Last Update: 2025-03-01
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

private _missionId = [_playerId] call vgm_g_fnc_missions_getAssignedMissionId;

[_missionId] call vgm_s_fnc_missions_getById // return
