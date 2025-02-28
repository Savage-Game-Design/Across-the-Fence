/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2025-02-25
    Public: No

    Description:
        Calculate amount of XP player should gain. Returns an array of "milestones" each awarding an amount of XP.

    Parameter(s):
        _endType - Mission end type, SUCCESS or FAILURE [STRING]
        _playerId - Id of the player that is being awareded the XP [STRING]

    Returns:
        Experiences to gain [ARRAY]

    Example(s):
        ["SUCCESS", "2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_endType", "_playerId"];

private _milestones = createHashMapFromArray [
    ["simple", []],
    ["scouting", []]
];

if (_endType == "SUCCESS") then {
    (_milestones get "simple") pushBack ["mission_success", 50];
};

// add XP for spotting and photos
[_playerId, _milestones get "scouting"] call vgm_s_fnc_missions_gameplay_scouting_calculateMilestones;

// zero it out for failure
if (_endType == "FAILURE") then {
    private _xp = 0;
    {
        _xp = _xp + (_x param [1, 0]);
    } forEach (_milestones get "simple");

    {
        private _siteMilestone = _x;
        {
            _xp = _xp + ((_siteMilestone get _x) param [1, 0]);
        } forEach ["type", "position", "photo"];
    } forEach (_milestones get "scouting");

    (_milestones get "simple") pushBack ["mission_failure", -_xp];
};

_milestones // return
