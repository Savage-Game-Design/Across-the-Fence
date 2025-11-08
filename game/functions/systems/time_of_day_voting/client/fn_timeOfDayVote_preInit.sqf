/*
    File: fn_timeOfDayVote_preInit.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-13
    Public: No

    Description:
        Time of day voting pre-init
 */

["vgm_timeOfDayVote_creationFailed", {
    params ["_eventData"];
    _eventData params ["_failureCode"];

    private _body = format ["STR_VGM_TIME_OF_DAY_VOTING_FAILURE_CODE_%1", _failureCode];

    if (_failureCode isEqualTo "VOTE_CALLED_RECENTLY") then {
        private _minutesRemaining = ceil ((vgm_g_timeOfDayVote_nextPossible - serverTime) / 60);
        // Format the response with the time remaining until the next vote.
        _body = [_body, _minutesRemaining];
    };

    createHashMapFromArray [
        ["title", "STR_VGM_TIME_OF_DAY_VOTING_CANT_START_VOTE"],
        ["body", _body]
    ] call vgm_c_fnc_postNotification;

}] call para_g_fnc_event_subscribeServer;
