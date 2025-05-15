/*
    File: fn_director_deleteEngagement.sqf
    Author:
    Date: 2025-04-28
    Last Update: 2025-05-15
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_director", "_engagement"];

_engagement set ["ended", true];
_director get "playerEngagements" deleteAt (_engagement get "playerHash");
[format ["[Engagement - Player %1] Engagement ended", _engagement get "player"]] call vgm_g_fnc_logDebug;
