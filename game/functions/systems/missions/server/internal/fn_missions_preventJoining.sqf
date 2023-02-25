/*
    File: fn_missions_preventJoining.sqf
    Author: Savage Game Design
    Date: 2023-04-24
    Last Update: 2023-06-20
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

private _isJoinable = count (_mission get "prevent joining") == 0;

if (_preventJoining) then {
    _mission get "prevent joining" set [_reason, true];
} else {
    _mission deleteAt _reason;
};

private _shouldBeJoinable = count (_mission get "prevent joining") == 0;

if (_shouldBeJoinable == _isJoinable) exitWith {};

[_mission] call vgm_s_fnc_missions_updateMissionDataOnClients;

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
