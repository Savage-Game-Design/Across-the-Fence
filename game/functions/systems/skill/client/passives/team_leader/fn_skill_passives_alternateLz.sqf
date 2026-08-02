/*
    File: fn_skill_passives_alternateLz.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        After calling for extraction, request an alternate LZ from Covey
        (max 3 times). Listens for the extraction started event and adds
        an action to request a different landing zone.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_alternateLz
 */

#define MAX_ALTERNATE_REQUESTS 3

params ["_known"];

if (!_known) exitWith {
    [vgm_c_skill_passives_alternateLz_extractionEh] call para_g_fnc_event_unsubscribe;
    player removeAction (player getVariable ["vgm_c_skill_alternateLz_action", -1]);
    player setVariable ["vgm_c_skill_alternateLz_action", -1];
};

vgm_c_skill_alternateLz_requestCount = 0;

// Listen for extraction start event
vgm_c_skill_passives_alternateLz_extractionEh = ["vgm_missions_gameplay_extractionStarted", {
    params ["_missionId", "_lzPos", "_helicopter"];

    // Only add action for the team leader
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission") exitWith {};

    // Reset counter for new extraction
    vgm_c_skill_alternateLz_requestCount = 0;

    // Remove old action if exists
    player removeAction (player getVariable ["vgm_c_skill_alternateLz_action", -1]);

    private _action = player addAction [
        localize "STR_VGM_SKILLS_SKILL_ALTERNATE_LZ_ACTION",
        {
            params ["_target", "_caller"];

            if (vgm_c_skill_alternateLz_requestCount >= MAX_ALTERNATE_REQUESTS) exitWith {
                hint localize "STR_VGM_SKILLS_SKILL_ALTERNATE_LZ_EXHAUSTED";
            };

            vgm_c_skill_alternateLz_requestCount = vgm_c_skill_alternateLz_requestCount + 1;

            // Request alternate LZ from server
            private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
            if (isNil "_currentMission") exitWith {};

            [_currentMission get "id", _caller] remoteExecCall ["vgm_s_fnc_skill_alternateLz_requestNewLz", 2];

            private _remaining = MAX_ALTERNATE_REQUESTS - vgm_c_skill_alternateLz_requestCount;
            hint format [localize "STR_VGM_SKILLS_SKILL_ALTERNATE_LZ_REQUESTED", _remaining];

            format ["Alternate LZ: Request %1/%2 by %3", vgm_c_skill_alternateLz_requestCount, MAX_ALTERNATE_REQUESTS, name _caller] call vgm_g_fnc_logInfo;
        },
        [],
        6,
        false,
        true,
        "",
        format ["vgm_c_skill_alternateLz_requestCount < %1", MAX_ALTERNATE_REQUESTS],
        5
    ];

    player setVariable ["vgm_c_skill_alternateLz_action", _action];
}] call para_g_fnc_event_subscribe;
