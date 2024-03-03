/*
    File: fn_dangerReport_playerFiredManHandler.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2024-03-03
    Public: No

    Description:
        "FiredMan" handler for the player, that reports gunshots and explosions.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        player addEventHandler ["FiredMan", vgm_c_fnc_dangerReport_playerFiredManHandler];
 */

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

private _recentShots = vgm_c_dangerReport_recentShots;
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

    private _config = (configFile >> "CfgAmmo" >> (typeOf _projectile));
    private _brightness = getNumber (_config >> "brightness");
    private _indirectHit = getNumber (_config >> "indirectHit");
    private _indirectHitRadius = getNumber (_config >> "indirectHitRadius");

    // Flares
    if (_brightness > 0) exitWith {
        [
            vgm_c_dangerReport_locEventGroup,
            _pos,
            _brightness * vgm_c_dangerReport_brightnessToRangeMultiplier,
            "player_flare",
            [_brightness]
        ] call vgm_g_fnc_locEvents_triggerEvent;
    };

    // Explosives
    if (_indirectHit > 0) exitWith {
        private _t = linearConversion [0, 30, _indirectHitRadius, 0, 1, true];
        private _dangerRadius = _t bezierInterpolation vgm_c_dangerReport_explosionRadiusBezierCurve;

        [
            vgm_c_dangerReport_locEventGroup,
            _pos,
            _dangerRadius,
            "player_explosion",
            [typeOf _projectile]
        ] call vgm_g_fnc_locEvents_triggerEvent;
    };
}];
