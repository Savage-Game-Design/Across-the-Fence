/*
    File: fn_missions_startClientsideMonitoring.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
    Public: No

    Description:
        Starts clientside data reporting for the director system.
        Gathers clientside-only data, such as explosions and aggregated shots fired.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_director_startClientsideMonitoring
 */

if (player getVariable ["vgm_c_director_monitoring", false]) exitWith {};

vgm_c_director_recentShotsTemplate = createHashMapFromArray [
    ["playerId", getPlayerID player],
    ["totalShots", 0],
    ["averagePosition", [0, 0, 0]],
    ["unsuppressedShots", 0],
    ["suppressedShots", 0]
];

vgm_c_director_recentShots = +vgm_c_director_recentShotsTemplate;

vgm_c_director_firedHandler = player addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

    private _recentShots = vgm_c_director_recentShots;
    private _previousTotalShots = _recentShots get "totalShots";

    _recentShots set ["averagePosition",
        (_recentShots get "averagePosition")
        vectorMultiply _previousTotalShots
        vectorAdd (getPosASL player)
        vectorMultiply (1 / (_previousTotalShots + 1))
    ];

    _recentShots set ["totalShots", _previousTotalShots + 1];
    _recentShots set ["unsuppressedShots", _previousTotalShots + 1];
    // TODO - Track whether shots are suppressed or not.
    _recentShots set ["suppressedShots",  0];

    _projectile addEventHandler ["Explode", {
        params ["_projectile", "_pos", "_velocity"];

        [
            "vgm_director_playerCausedExplosion",
            createHashMapFromArray [
                ["playerId", getPlayerID player],
                ["pos", _pos]
            ]
        ] call para_g_fnc_event_triggerServer;
    }];
}];

// Sends the aggregated shooting statistics to the server.
vgm_c_director_sendRecentShotsJobId =
    [
        "vgm_director_sendRecentShotsToServer",
        vgm_c_fnc_director_sendRecentShotsToServer,
        [],
        5
    ] call para_g_fnc_scheduler_add_job;

vgm_c_director_monitoring = true;
