/*
    File: fn_missions_gameplay_hatchet_calculateMilestones.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Calculate XP milestones for a Hatchet Force mission.

    Parameter(s):
        _playerId - Id of the player being awarded XP [STRING]

    Returns:
        Array of milestone entries [ARRAY]

    Example(s):
        [_playerId] call vgm_s_fnc_missions_gameplay_hatchet_calculateMilestones;
 */

params ["_playerId"];

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {[]};

private _hatchetData = [_mission get "public" get "id", "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_hatchetData") exitWith {[]};

private _milestones = [];

// NPCs alive when players arrive: 50 XP each (up to 150)
private _aliveOnArrival = _hatchetData getOrDefault ["reconTeamAlive", 0];
if (_aliveOnArrival > 0) then {
    _milestones pushBack ["hatchet_team_alive", _aliveOnArrival * 50, _aliveOnArrival];
} else {
    _milestones pushBack ["hatchet_team_alive", 0, 0];
};

// NPCs extracted: 50 XP each (up to 150)
private _rescued = _hatchetData getOrDefault ["reconTeamRescued", 0];
if (_rescued > 0) then {
    _milestones pushBack ["hatchet_team_extracted", _rescued * 50, _rescued];
} else {
    _milestones pushBack ["hatchet_team_extracted", 0, 0];
};

// All 3 NPCs extracted alive: 75 XP bonus
if (_rescued >= 3) then {
    _milestones pushBack ["hatchet_full_team_bonus", 75];
};

// Hot LZ completion bonus: 50 XP
private _insertionType = _hatchetData getOrDefault ["insertionType", "cold"];
if (_insertionType == "hot" && _rescued > 0) then {
    _milestones pushBack ["hatchet_hot_lz_bonus", 50];
};

_milestones
