/*
    File: fn_missions_getHubSpawnPos.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2024-07-21
    Public: Yes

    Description:
        Gets the position the shared hub where the player should respawn.

    Parameter(s):
        None

    Returns:
        [PositionASL, Direction] [ARRAY]

    Example(s):
        [] call vgm_g_fnc_missions_getHubSpawnPos;
 */

#define MARKER "vgm_shared_hub_respawn"

private _pos = markerPos MARKER;
private _safePos = _pos findEmptyPosition [1, 15, "CAManBase"];
private _dir = markerDir MARKER;

if (_safePos isEqualTo []) exitWith {
    [_pos, _dir]
};

[_safePos, _dir]

