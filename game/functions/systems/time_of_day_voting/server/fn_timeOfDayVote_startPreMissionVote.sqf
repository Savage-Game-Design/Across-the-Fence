/*
    File: fn_timeOfDayVote_startVote.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-11-13
    Public: No

    Description:
        Starts a new vote to set the time of day.

    Parameter(s):
        None

    Returns:
        Reason vote couldn't be called, or ""

    Example(s):
        [] call vgm_s_fnc_timeOfDayVote_startPreMissionVote;
 */

#define MINIMUM_TIME_BETWEEN_VOTES_SECS 300

if (vgm_g_timeOfDayVote_nextPossible > serverTime) exitWith { "VOTE_CALLED_RECENTLY" };

private _allMissions = [] call vgm_s_fnc_missions_getAllMissions;
private _activeMissionIndex = _allMissions findIf {_x get "public" get "status" isEqualTo "IN PROGRESS"};

if (_activeMissionIndex > -1) exitWith {
    "MISSION_IN_PROGRESS"
};

vgm_s_timeOfDayVote_inProgress = true;

[
    "STR_VGM_TIME_OF_DAY_VOTING_PREMISSION_VOTE_TITLE",
    "STR_VGM_TIME_OF_DAY_VOTING_PREMISSION_VOTE_CONTENT",
    [
        ["STR_VGM_TIME_OF_DAY_VOTING_PREMISSION_VOTE_OPTION_1", 08],
        ["STR_VGM_TIME_OF_DAY_VOTING_PREMISSION_VOTE_OPTION_2", 18]
    ],
    60,
    {
        vgm_s_timeOfDayVote_inProgress = false;
        _this # 1 call vgm_s_fnc_timeOfDayVote_setTime
    }
] call para_s_fnc_create_vote;

missionNamespace setVariable ["vgm_g_timeOfDayVote_nextPossible", serverTime + MINIMUM_TIME_BETWEEN_VOTES_SECS, true];

nil
