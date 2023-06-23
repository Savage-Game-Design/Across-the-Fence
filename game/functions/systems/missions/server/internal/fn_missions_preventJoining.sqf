/*
    File: fn_missions_preventJoining.sqf
    Author: Savage Game Design
    Date: 2023-04-24
    Last Update: 2023-06-23
    Public: No

    Description:
        Sets a joinability property saying if the mission can or can't be joined.

        A mission cannot be joined if any reason is "true", i.e, if any system says the mission can't be joined.

        Updates the mission and broadcasts events if there's a change in status.

    Parameter(s):
        _mission - Mission to set property on [HASHMAP]
        _reason - Reason the mission isn't joinable, can be anything [ANY HASHABLE]
        _preventJoining - True to prevent joining, false otherwise [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        ["mission full", true] call vgm_s_fnc_missions_preventJoining;

 */
params ["_mission", "_reason", "_preventJoining"];

private _missionPublic = _mission get "public";
private _preventJoiningReasons = _missionPublic get "preventJoining";

private _isJoinable = (_preventJoiningReasons call para_g_fnc_netmap_count) == 0;

if (_preventJoining) then {
    [_preventJoiningReasons, _reason, true] call para_s_fnc_netmap_set;
} else {
    [_preventJoiningReasons, _reason] call para_s_fnc_netmap_deleteAt;
};

private _shouldBeJoinable = (_preventJoiningReasons call para_g_fnc_netmap_count) == 0;

if (_shouldBeJoinable == _isJoinable) exitWith {};

if (_shouldBeJoinable) then {
    [
        "mission joinable",
        [_mission get "id"]
    ] call para_g_fnc_event_triggerGlobal;
} else {
    [
        "mission stopped being joinable",
        [_mission get "id"]
    ] call para_g_fnc_event_triggerGlobal;
};
