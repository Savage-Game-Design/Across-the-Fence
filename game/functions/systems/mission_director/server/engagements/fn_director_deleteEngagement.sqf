/*
    File: fn_director_deleteEngagement.sqf
    Author: Savage Game Design
    Date: 2025-04-28
    Last Update: 2025-06-19
    Public: Yes

    Description:
        Deletes an existing engagement, forcibly ending it.

    Parameter(s):
        _director - Mission director for the current mission [HASHMAP]
        _engagement - Engagement to remove [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_director, _engagement] call vgm_s_fnc_director_deleteEngagement;
 */

params ["_director", "_engagement"];

_engagement set ["ended", true];
_director get "playerEngagements" deleteAt (_engagement get "playerHash");
[format ["[Engagement - Player %1] Engagement ended", _engagement get "player"]] call vgm_g_fnc_logDebug;
