/*
    File: fn_missions_gameplay_snatch_calculateMilestones.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Calculate XP milestones for a Prisoner Snatch mission.

    Parameter(s):
        _playerId - Id of the player being awarded XP [STRING]

    Returns:
        Array of milestone entries [ARRAY]

    Example(s):
        [_playerId] call vgm_s_fnc_missions_gameplay_snatch_calculateMilestones;
 */

params ["_playerId"];

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {[]};

private _snatchData = [_mission get "public" get "id", "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_snatchData") exitWith {[]};

private _milestones = [];

// Target captured alive: 175 XP
private _captured = _snatchData getOrDefault ["targetCaptured", false];
if (_captured) then {
    _milestones pushBack ["snatch_target_captured", 175];
} else {
    _milestones pushBack ["snatch_target_captured", 0];
};

// Target extracted: 125 XP
private _extracted = _snatchData getOrDefault ["targetExtracted", false];
if (_extracted) then {
    _milestones pushBack ["snatch_target_extracted", 125];
} else {
    _milestones pushBack ["snatch_target_extracted", 0];
};

// Zero friendly casualties bonus: 50 XP
private _playerGroup = _mission get "public" get "group";
private _allAlive = (units _playerGroup) findIf {isPlayer _x && !alive _x} == -1;
if (_allAlive && _captured) then {
    _milestones pushBack ["snatch_no_casualties", 50];
};

_milestones
