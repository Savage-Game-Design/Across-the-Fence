/*
    File: fn_timeOfDayVote_remoteExec_startPreMissionVote.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-13
    Public: Yes

    Description:
        Starts a pre-mission vote, remote executed from the client.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_s_fnc_timeOfDayVote_remoteExec_startPreMissionVote", 2];
 */

private _failureCode = [] call vgm_s_fnc_timeOfDayVote_startPreMissionVote;

if (!isNil "_failureCode" && remoteExecutedOwner != 0) then {
    ["vgm_timeOfDayVote_creationFailed", [_failureCode], remoteExecutedOwner] call para_g_fnc_event_triggerTargets;
};
