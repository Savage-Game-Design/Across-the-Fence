/*
    File: fn_mortar_fireRound.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Fires a single mortar round at a target position with a given dispersion radius.
        Spawns the shell at altitude above the impact point with downward velocity.

    Parameter(s):
        _targetPos  - Target position ATL [Array]
        _dispersion - Maximum offset radius in meters [Number]

    Returns:
        Nothing

    Example(s):
        [getPos player, 100] call vgm_s_fnc_mortar_fireRound;
*/

params ["_targetPos", "_dispersion"];

// Apply random offset within dispersion radius
private _angle = random 360;
private _distance = random _dispersion;
private _offsetX = _distance * sin _angle;
private _offsetY = _distance * cos _angle;

private _impactPos = [
    (_targetPos # 0) + _offsetX,
    (_targetPos # 1) + _offsetY,
    0
];

// Get terrain height at impact point
private _terrainZ = getTerrainHeightASL _impactPos;

// Spawn shell above impact point
private _spawnPos = [
    _impactPos # 0,
    _impactPos # 1,
    _terrainZ + vgm_s_mortar_shellSpawnAltitude
];

private _shell = createVehicle [vgm_s_mortar_shellClassname, ASLToATL _spawnPos, [], 0, "FLY"];
_shell setVectorUp [0, 0, -1];
_shell setVelocity [0, 0, vgm_s_mortar_shellDownVelocity];

[format ["[Mortar] Round fired at [%1, %2] (dispersion=%3m, offset=%4m)",
    round (_impactPos # 0), round (_impactPos # 1), _dispersion, round _distance
]] call vgm_g_fnc_logInfo;
