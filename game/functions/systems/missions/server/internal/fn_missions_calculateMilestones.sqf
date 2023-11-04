/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2023-10-15
    Public: No

    Description:
        Calculate amount of XP player should gain. Returns an array of "milestones" each awarding an amount of XP.

    Parameter(s):
        _playerId - Id of the player that is being awareded the XP [STRING]

    Returns:
        Experiences to gain [ARRAY]

    Example(s):
        ["2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_playerId"];

[
    ["mission", 500] // simple hardcoded amount for now
    // ["invincible", 100] // We could give bonus XP for certain things, not being downed at all during the mission etc.
] // return
