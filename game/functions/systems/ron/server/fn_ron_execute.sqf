/*
    File: fn_ron_execute.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Server-side handler for Remain Overnight (RON). Initiates a vote among
        all players. If the vote passes, gives 2 minutes to prepare positions,
        then fades to black and rolls for outcome:
          - 75% quiet night: flavor text, skip to dawn
          - 25% contact: flavor text, spawn NVA probe around each group

    Parameter(s):
        _caller - Player who initiated the RON [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_caller] remoteExecCall ["vgm_s_fnc_ron_execute", 2];
 */

#define RON_PREP_DURATION 120
#define RON_COOLDOWN 600
#define RON_CONTACT_CHANCE 0.25

params ["_caller"];

if (!isServer) exitWith {};

// --- Validation ---

// Check if RON is already in progress
if (missionNamespace getVariable ["vgm_s_ron_active", false]) exitWith {
    format ["RON: Already in progress, rejected from %1", name _caller] call vgm_g_fnc_logInfo;
};

// Check if a vote is already in progress
if (missionNamespace getVariable ["vgm_s_ron_voteInProgress", false]) exitWith {
    format ["RON: Vote already in progress, rejected from %1", name _caller] call vgm_g_fnc_logInfo;
};

// Check cooldown
if (serverTime < (missionNamespace getVariable ["vgm_s_ron_nextPossible", 0])) exitWith {
    format ["RON: On cooldown, rejected from %1", name _caller] call vgm_g_fnc_logInfo;
};

// Must be nighttime
private _hour = date select 3;
private _time = _hour + ((date select 4) / 100);
if (!(_time >= 18 || _time < 5.15)) exitWith {
    format ["RON: Not nighttime (time: %1), rejected from %2", _time, name _caller] call vgm_g_fnc_logInfo;
};

// --- Initiate Vote ---
vgm_s_ron_voteInProgress = true;

[
    "STR_VGM_RON_VOTE_TITLE",
    "STR_VGM_RON_VOTE_CONTENT",
    [
        ["STR_VGM_RON_VOTE_YES", true],
        ["STR_VGM_RON_VOTE_NO", false]
    ],
    45,
    {
        params ["_voteResult", "_value"];

        vgm_s_ron_voteInProgress = false;

        if (!_value) exitWith {
            "RON: Vote rejected" call vgm_g_fnc_logInfo;
        };

        // Vote passed — start prep phase
        vgm_s_ron_active = true;
        publicVariable "vgm_s_ron_active";

        "RON: Vote passed. 2 minute prep phase starting." call vgm_g_fnc_logInfo;

        // Gather player names per group for flavor text
        private _activeGroups = allGroups select {
            (side _x == west)
            && {{alive _x && isPlayer _x} count units _x > 0}
        };

        private _groupData = _activeGroups apply {
            private _players = (units _x) select {isPlayer _x && alive _x};
            private _names = _players apply {name _x};
            [_x, _players, _names]
        };

        // Notify all players of prep phase with deadline
        private _deadline = serverTime + RON_PREP_DURATION;
        [_deadline] remoteExecCall ["vgm_c_fnc_ron_prepTimer", 0];

        // Wait for prep phase to complete
        [_groupData] spawn {
            params ["_groupData"];

            sleep RON_PREP_DURATION;

            // Roll outcome (one roll for everyone)
            private _isContact = random 1 < RON_CONTACT_CHANCE;
            private _outcome = if (_isContact) then {"contact"} else {"quiet"};

            format ["RON: Outcome — %1", _outcome] call vgm_g_fnc_logInfo;

            // Send cinematic to all players with their group's names
            {
                _x params ["_group", "_players", "_names"];
                [_outcome, _names] remoteExec ["vgm_c_fnc_ron_cinematic", _players];
            } forEach _groupData;

            // Wait for cinematic to play out before spawning/time change
            if (_isContact) then {
                // Contact: wait for fade + text, then spawn, then fade in
                sleep 8;
                // Spawn probe for each group
                {
                    _x params ["_group", "_players"];
                    [_players] call vgm_s_fnc_ron_spawnProbe;
                } forEach _groupData;
                // Small delay then tell clients to fade back in
                sleep 2;
                [false] remoteExecCall ["vgm_c_fnc_ron_fadeScreen", 0];
            } else {
                // Quiet: wait for fade + text, skip to dawn, then fade in
                sleep 8;
                // Set time to 05:30 (just before dawn)
                private _d = date;
                _d set [3, 5];
                _d set [4, 30];
                setDate _d;
                sleep 1;
                [false] remoteExecCall ["vgm_c_fnc_ron_fadeScreen", 0];
            };

            // Cleanup
            vgm_s_ron_active = false;
            publicVariable "vgm_s_ron_active";

            // Set cooldown
            missionNamespace setVariable ["vgm_s_ron_nextPossible", serverTime + RON_COOLDOWN, true];

            format ["RON: Complete. Cooldown until %1", serverTime + RON_COOLDOWN] call vgm_g_fnc_logInfo;
        };
    }
] call para_s_fnc_create_vote;

format ["RON: Vote initiated by %1", name _caller] call vgm_g_fnc_logInfo;
