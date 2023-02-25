/*
    File: fn_missions_setCurrentMission.sqf
    Author:
    Date: 2023-04-23
    Last Update: 2023-04-24
    Public: No

    Description:
        Sets the current mission the player is assigned to

    Parameter(s):
        _missionId - ID of the mission the player is assigned to

    Returns:
        Nothing

    Example(s):
        [_mission get "id"] remoteExecCall ["vgm_c_fnc_missions_setCurrentMission"]
 */

params ["_missionId"];

private _missionsData = localNamespace getVariable "vgm_c_missions_data";
if (isNil "_missionId") then {
    _missionsData deleteAt "currentMission";
} else {
    _missionsData set ["currentMission", _missionId];
};
