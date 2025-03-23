/*
    File: fn_missions_reportFiredDataToServer.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2024-03-03
    Public: No

    Description:
        Sends an aggregate of recent shots fired on the client to the server.

    Parameter(s):
        Identical to "FiredMan" Arma 3 event handler.

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_director_sendRecentShotsToServer;
 */

if (vgm_c_dangerReport_recentShots get "totalShots" == 0) exitWith {};

// Works because there must be at least 1 shot fired to get this far.
private _notifyRadius = [
    vgm_c_dangerReport_suppressedShotsNotifyDistance,
    vgm_c_dangerReport_unsuppressedShotsNotifyDistance
] select (vgm_c_dangerReport_recentShots get "unsuppressedShots" > 0);

[
    vgm_c_dangerReport_locEventGroup,
    vgm_c_dangerReport_recentShots get "averagePosition",
    _notifyRadius,
    "player_gunshots_aggregate",
    vgm_c_dangerReport_recentShots
] call vgm_g_fnc_locEvents_triggerEvent;

// Reset all values to default for the next time period.
vgm_c_dangerReport_recentShots = +vgm_c_dangerReport_shotsAggregateTemplate;
