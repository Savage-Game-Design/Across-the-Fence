/*
    File: fn_missions_gameplay_bright_light_calculateMilestones.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Calculate XP milestones for a Bright Light Rescue mission.

    Parameter(s):
        _playerId - Id of the player being awarded XP [STRING]

    Returns:
        Array of milestone entries [ARRAY]

    Example(s):
        [_playerId] call vgm_s_fnc_missions_gameplay_bright_light_calculateMilestones;
 */

params ["_playerId"];

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {[]};

private _blData = [_mission get "public" get "id", "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_blData") exitWith {[]};

// No bright light event was triggered — netmap exists but pilot variant was never set
if (_blData getOrDefault ["pilotVariant", ""] isEqualTo "") exitWith {[]};

private _milestones = [];

// Target found (player got within 25m): 50 XP
private _found = _blData getOrDefault ["targetFound", false];
if (_found) then {
    _milestones pushBack ["bright_light_target_found", 50];
} else {
    _milestones pushBack ["bright_light_target_found", 0];
};

// Target rescued (carried): 125 XP
private _rescued = _blData getOrDefault ["targetRescued", false];
if (_rescued) then {
    _milestones pushBack ["bright_light_target_rescued", 125];
} else {
    _milestones pushBack ["bright_light_target_rescued", 0];
};

// Target extracted (on helicopter): 175 XP
private _extracted = _blData getOrDefault ["targetExtracted", false];
if (_extracted) then {
    _milestones pushBack ["bright_light_target_extracted", 175];
} else {
    _milestones pushBack ["bright_light_target_extracted", 0];
};

_milestones
