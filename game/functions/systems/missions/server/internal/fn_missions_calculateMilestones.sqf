/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2025-03-05
    Public: No

    Description:
        Calculate amount of XP player should gain.

    Parameter(s):
        _endType - Mission end type, SUCCESS or FAILURE [STRING]
        _playerId - Id of the player that is being awareded the XP [STRING]

    Returns:
        Milestones details, Total experience to gain [ARRAY]

    Example(s):
        ["SUCCESS", "2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_endType", "_playerId"];

// milestone entries - <Type specific data, XP to gain> - <ANY, NUMBER>
private _milestones = createHashMapFromArray [
    ["simple", []],
    ["scouting", []]
];

if (_endType == "SUCCESS") then {
    (_milestones get "simple") pushBack ["mission_success", 50];
};

// add XP for spotting and photos
[_playerId, _milestones get "scouting"] call vgm_s_fnc_missions_gameplay_scouting_calculateMilestones;

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
