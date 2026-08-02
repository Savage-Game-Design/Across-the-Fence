/*
    File: fn_radiocheckin_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server-side initialization for the radio check-in system.
        Tracks check-in state per mission. The player is responsible for
        checking in every 30 minutes — no prompts from COVEY. Missing a
        window silently increments the missed count. On check-in completion,
        plays the voice line sequence (Columbia report → COVEY acknowledge).

        State is stored directly on the mission hashmap:
        - vgm_s_checkin_lastTime    : serverTime of last check-in (or deploy)
        - vgm_s_checkin_missedCount : number of missed 30-min windows
        - vgm_s_checkin_active      : whether the monitor loop is running

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_radiocheckin_postInit;
*/

if (!isServer) exitWith {};

// When a mission starts, initialize check-in state
["vgm_mission_started", {
    params ["_eventData"];
    _eventData params ["_missionId"];

    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission") exitWith {};

    _mission set ["vgm_s_checkin_lastTime", serverTime];
    _mission set ["vgm_s_checkin_missedCount", 0];
    _mission set ["vgm_s_checkin_active", true];

    // Spawn monitor loop for this mission
    [_missionId] spawn {
        params ["_missionId"];

        // Wait for deploy (initial 60s grace period after mission start)
        sleep 60;

        private _mission = [_missionId] call vgm_s_fnc_missions_getById;
        if (isNil "_mission") exitWith {};

        // Reset timer after grace period so first 30-min window starts now
        _mission set ["vgm_s_checkin_lastTime", serverTime];

        while {_mission getOrDefault ["vgm_s_checkin_active", false]} do {
            sleep 5;

            // Re-fetch in case mission ended
            _mission = [_missionId] call vgm_s_fnc_missions_getById;
            if (isNil "_mission") exitWith {};
            if (!(_mission getOrDefault ["vgm_s_checkin_active", false])) exitWith {};

            private _lastTime = _mission getOrDefault ["vgm_s_checkin_lastTime", serverTime];
            private _elapsed = serverTime - _lastTime;

            // 30-minute window (1800s) expired without check-in
            if (_elapsed >= 1800) then {
                private _missed = _mission getOrDefault ["vgm_s_checkin_missedCount", 0];
                _missed = _missed + 1;
                _mission set ["vgm_s_checkin_missedCount", _missed];
                _mission set ["vgm_s_checkin_lastTime", serverTime];

                format ["VGM RadioCheckIn: Missed check-in #%1 for mission %2", _missed, _missionId] call vgm_g_fnc_logWarning;
            };
        };
    };
}] call para_g_fnc_event_subscribe;

// On mission end: stop the monitor loop
["vgm_mission_ended", {
    params ["_eventData"];
    _eventData params ["_missionId"];

    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (!isNil "_mission") then {
        _mission set ["vgm_s_checkin_active", false];
    };
}] call para_g_fnc_event_subscribe;

"VGM: Radio check-in system initialized" call vgm_g_fnc_logInfo;
