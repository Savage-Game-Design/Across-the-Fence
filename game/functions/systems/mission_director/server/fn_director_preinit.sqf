/*
    File: fn_director_preinit.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2024-04-24
    Public: No

    Description:
        Preinit for the mission director system

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_director_preinit;
 */

vgm_s_director_unsuppressed_listen_range = 150;
vgm_s_director_suppressed_listen_range = 75;
vgm_s_director_explosion_listen_range = 350;
vgm_s_director_investigate_track_chance = 0.5;
vgm_s_director_max_alertness = 30;
vgm_s_director_min_time_between_trackers_secs = 90;
vgm_s_director_max_time_between_trackers_secs = 300;
vgm_s_director_patrol_max_groups = 10;
vgm_s_director_dynamic_max_groups = 8;

// TODO - Replace these with Mike Force's squad generator
vgm_s_director_patrol_classes = [
    'vn_o_men_nva_02',
    'vn_o_men_nva_05',
    'vn_o_men_nva_09',
    'vn_o_men_nva_10'
];

vgm_s_directotr_tracker_classes = [
    'vn_o_men_nva_10',
    'vn_o_men_nva_05',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06'
];

vgm_s_director_attack_classes = [
    'vn_o_men_nva_11',
    'vn_o_men_nva_49',
    'vn_o_men_nva_11',
    'vn_o_men_nva_07',
    'vn_o_men_nva_49'
];

[
    "vgm_director_playerCausedExplosion",
    // Wrapped in code block to allow recompilation when testing.
    { _this call vgm_s_fnc_director_handlePlayerExplosion }
] call para_g_fnc_event_subscribe;

[
    "vgm_director_recentPlayerShots",
    // Wrapped in code block to allow recompilation when testing.
    { _this call vgm_s_fnc_director_handlePlayerShots }
] call para_g_fnc_event_subscribe;

[
    "vgm_medical_unconscious",
    {
        (_this # 0) params ["_unit", "_state"];

        if (!_state) exitWith {};

        private _playerId = getPlayerID _unit;

        if !([getPlayerID _unit] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

        private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;

        if (isNil "_mission") exitWith {};

        private _playersOnMission = units _unit;
        private _alivePlayers = _playersOnMission select {alive _x && {lifeState _x != "INCAPACITATED"}};

        if (_alivePlayers isNotEqualTo []) exitWith {};

        [_mission get "public" get "id", "FAILURE"] call vgm_s_fnc_missions_endMission;
    }
] call para_g_fnc_event_subscribe;

["vgm_mission_attached", {
    (_this#0) params ["_playerId", "_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission" || {(_mission get "public" get "status") != "IN PROGRESS"}) exitWith {};
    getUserInfo _playerId params ["", "_machineId"];

    [] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", _machineId];

    ["vgm_mission_director_jipData", [_mission get "director" get "aiGroups"], _machineId] call para_g_fnc_event_triggerTargets;
}] call para_g_fnc_event_subscribeLocal;
