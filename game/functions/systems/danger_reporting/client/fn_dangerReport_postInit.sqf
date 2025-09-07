/*
    File: fn_dangerReport_postInit.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2025-08-30
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

vgm_c_dangerReport_suppressedShotsNotifyDistance = 100;
vgm_c_dangerReport_unsuppressedShotsNotifyDistance = 200;

vgm_c_dangerReport_explosion_minNotifyDistance = 75;
vgm_c_dangerReport_explosion_maxNotifyDistance = 400;

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
// Caches if a gunshot is suppressed or not, using the gunshot's characteristics as a key (ammo, muzzle attachment)
vgm_c_dangerReport_shotSuppressionCache = createHashMap;

[
    "vgm_mission_deploy_local",
    {
        params ["_publicMissionInfo"];

        if !(isNil "vgm_c_dangerReport_playerFiredManHandler") exitWith {
            [format ["Attempting to setup danger reporting on %1 twice", player]] call vgm_g_fnc_logWarning;
        };

        vgm_c_dangerReport_locEventGroup = _publicMissionInfo get "id";

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
        params ["_publicMissionInfo"];

        if (isNil "vgm_c_dangerReport_playerFiredManHandler") exitWith {
            [format ["Attempting to disable danger reporting, but it's already disabled", player]] call vgm_g_fnc_logWarning;
        };

        vgm_c_dangerReport_locEventGroup = vgm_g_dangerReport_defaultLocEventGroup;

        player removeEventHandler ["FiredMan", vgm_c_dangerReport_playerFiredManHandler];
        vgm_c_dangerReport_playerFiredManHandler = nil;

        [vgm_c_dangerReport_sendRecentShotsJobId] call para_g_fnc_scheduler_removeJob;
        vgm_c_dangerReport_sendRecentShotsJobId = nil;
    }
] call para_g_fnc_event_subscribeLocal;
