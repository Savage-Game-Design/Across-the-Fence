/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2025-03-06
    Public: No

    Description:
        Calculate amount of XP player should gain.

    Parameter(s):
        _endType - Mission end type, SUCCESS or FAILURE [STRING]
        _playerId - Id of the player that is being awarded the XP [STRING]

    Returns:
        Milestones details, Total experience to gain [ARRAY]

    Example(s):
        ["SUCCESS", "2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_endType", "_playerId"];

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
private _missionType = if (!isNil "_mission") then {
    (_mission get "parameters") getOrDefault ["missionType", "scouting"]
} else {"scouting"};

// milestone entries - <Type specific data, XP to gain> - <ANY, NUMBER>
private _milestones = createHashMapFromArray [
    ["simple", []]
];

// Add type-specific milestones
switch (_missionType) do {
    case "scouting": {
        _milestones set ["scouting", [_playerId] call vgm_s_fnc_missions_gameplay_scouting_calculateMilestones];
        // Bright Light side mission (CAS shootdown rescue) — award XP if netmap exists
        private _blCheck = if (!isNil "_mission") then {
            [_mission get "public" get "id", "bright_light"] call vgm_s_fnc_missions_getSystemNetmap
        } else {nil};
        if (!isNil "_blCheck") then {
            _milestones set ["bright_light", [_playerId] call vgm_s_fnc_missions_gameplay_bright_light_calculateMilestones];
        };
        // Officer snatch bonus (random world event)
        if (!isNil "_mission") then {
            private _scoutData = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
            if (!isNil "_scoutData") then {
                if (_scoutData getOrDefault ["officerExtracted", false]) then {
                    (_milestones get "simple") pushBack ["officer_extracted", 200];
                } else {
                    if (_scoutData getOrDefault ["officerKilled", false]) then {
                        (_milestones get "simple") pushBack ["officer_killed", 75];
                    };
                };
            };
        };
    };
    case "prisoner_snatch": {
        _milestones set ["snatch", [_playerId] call vgm_s_fnc_missions_gameplay_snatch_calculateMilestones];
    };
    case "bright_light": {
        _milestones set ["bright_light", [_playerId] call vgm_s_fnc_missions_gameplay_bright_light_calculateMilestones];
    };
    case "hatchet_force": {
        _milestones set ["hatchet", [_playerId] call vgm_s_fnc_missions_gameplay_hatchet_calculateMilestones];
    };
};

if (_endType == "SUCCESS") then {
    (_milestones get "simple") pushBack ["mission_success", 75];
};

private _kills = if (!isNil "_mission") then {_mission getOrDefault ["vgm_s_missionKills", 0]} else {0};
if (_kills > 0) then {
    _milestones set ["combat", [["enemy_kills", _kills * 5, _kills]]];
};

// Vehicle photos are now scored through the scouting site pipeline (virtual sites)

// Radio check-in penalty
private _missedCheckins = if (!isNil "_mission") then {_mission getOrDefault ["vgm_s_checkin_missedCount", 0]} else {0};
if (_missedCheckins > 0) then {
    (_milestones get "simple") pushBack ["missed_radio_checkin", -15 * _missedCheckins, _missedCheckins];
};

private _xp = 0;
{
    {_xp = _xp + (_x param [1, 0])} forEach _y;
} forEach _milestones;

// zero it out for failure
if (_endType == "FAILURE") then {
    (_milestones get "simple") pushBack ["mission_failure", -_xp];
    _xp = 0;
};

[_milestones, _xp] // return
