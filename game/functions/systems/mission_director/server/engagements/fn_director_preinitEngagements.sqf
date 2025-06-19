/*
    File: fn_director_preinitEngagements.sqf
    Author: Savage Game Design
    Date: 2025-06-19
    Last Update: 2025-06-19
    Public: No

    Description:
        Preinit for the engagements component of the mission director

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_director_preinitEngagements;
 */

["vgm_ai_groupTargetsEngaged", {
    (_this # 0) params ["_group", "_targets"];

    private _missionId = _group getVariable "vgm_g_missionId";
    private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
    if (isNil "_director") exitWith {};
    {
        [_director, _group, _x] call vgm_s_fnc_director_addEnemyGroupToPlayerEngagement;
    } forEach _targets;
}] call para_g_fnc_event_subscribe;

["vgm_ai_groupTargetsLost", {
    (_this # 0) params ["_group", "_targets"];

    private _missionId = _group getVariable "vgm_g_missionId";
    private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
    if (isNil "_director") exitWith {};
    {
        [_director, _group, _x] call vgm_s_fnc_director_removeEnemyGroupFromPlayerEngagement;
    } forEach _targets;
}] call para_g_fnc_event_subscribe;
