/*
    File: fn_dangerReport_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2024-03-03
    Public: Yes

    Description:
        Preinit for sound reporting.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

vgm_c_dangerReport_suppressedShotsNotifyDistance = 50;
vgm_c_dangerReport_unsuppressedShotsNotifyDistance = 120;

// Multiplier to convert flare brightness to range.
vgm_c_dangerReport_brightnessToRangeMultiplier = 2 / 3;

vgm_c_dangerReport_shotsAggregateTemplate = createHashMapFromArray [
    ["playerId", getPlayerID player],
    ["totalShots", 0],
    ["averagePosition", [0, 0, 0]],
    ["unsuppressedShots", 0],
    ["suppressedShots", 0]
];

// Data structure for this player's recent gunfire
vgm_c_dangerReport_recentShots = +vgm_c_dangerReport_shotsAggregateTemplate;

vgm_c_dangerReport_sendRecentShotsJobId = nil;
vgm_c_dangerReport_playerFiredManHandler = nil;

[
    "vgm_mission_deploy_local",
    {
        if !(isNil "vgm_c_dangerReport_playerFiredManHandler") exitWith {
            [format ["Attempting to setup danger reporting on %1 twice", player]] call vgm_g_fnc_logWarning;
        };

        vgm_c_dangerReport_playerFiredManHandler =
            player addEventHandler ["FiredMan", vgm_c_fnc_dangerReport_playerFiredManHandler];

        vgm_c_dangerReport_sendRecentShotsJobId =
            [
                "vgm_dangerReport_sendRecentShotsToServer",
                vgm_c_fnc_dangerReport_sendRecentShotsToServer,
                [],
                5
            ] call para_g_fnc_scheduler_add_job;
    }
] call para_g_fnc_event_subscribeLocal;

[
    "vgm_mission_end_local",
    {
        if (isNil "vgm_c_dangerReport_playerFiredManHandler") exitWith {
            [format ["Attempting to disabled danger reporting, but it's already disabled", player]] call vgm_g_fnc_logWarning;
        };

        player removeEventHandler ["FiredMan", vgm_c_dangerReport_playerFiredManHandler];
        vgm_c_dangerReport_playerFiredManHandler = nil;

        [vgm_c_dangerReport_sendRecentShotsJobId] call para_g_fnc_scheduler_removeJob;
        vgm_c_dangerReport_sendRecentShotsJobId = nil;
    }
] call para_g_fnc_event_subscribeLocal;
