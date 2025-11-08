/*
    File: fn_timeOfDayVote_preInit.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-11-13
    Public: No

    Description:
        Time of day voting pre-init
 */

vgm_s_timeOfDayVote_inProgress = false;
vgm_g_timeOfDayVote_nextPossible = 0;
publicVariable "vgm_g_timeOfDayVote_nextPossible";

[localNamespace, "vgm_s_missions_canStartMissionCheck", {
    private _currentVote = [] call para_s_fnc_current_vote;

    // Check if there's any current vote or not as some extra protection against errors.
    if (vgm_s_timeOfDayVote_inProgress && !isNil "_currentVote") exitWith {
        "TIME_OF_DAY_VOTE_IN_PROGRESS"
    };

    nil
}] call BIS_fnc_addScriptedEventHandler;
