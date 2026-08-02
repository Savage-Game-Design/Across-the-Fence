/*
    File: fn_skill_actives_dynamite.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — Dynamite. Calculates 7 positions in a fan arc
        (-45 to +45 degrees, 10-25m ahead of player) and spawns
        claymore mines at those positions via server.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_dynamite
 */

#define NUM_MINES 7
#define MIN_DIST 10
#define MAX_DIST 25
#define ARC_HALF 45

params ["", "_skill"];

["Tail/Dynamite skill activated"] call vgm_g_fnc_logInfo;

private _playerPos = getPosATL player;
private _playerDir = getDir player;
private _positions = [];

// Generate 7 positions in a fan arc
for "_i" from 0 to (NUM_MINES - 1) do {
    private _angle = _playerDir + linearConversion [0, NUM_MINES - 1, _i, -ARC_HALF, ARC_HALF];
    private _dist = MIN_DIST + random (MAX_DIST - MIN_DIST);
    private _pos = _playerPos getPos [_dist, _angle];
    _pos set [2, 0];
    _positions pushBack _pos;
};

[_positions, playerSide] remoteExecCall ["vgm_s_fnc_skill_dynamite_spawnClaymores", 2];
