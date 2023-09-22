/*
    File: fn_missions_getHubSpawnPos.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-09-19
    Public: Yes

    Description:
        Gets the position the shared hub where the player should respawn.

    Parameter(s):
        None

    Returns:
        PositionASL [ARRAY]

    Example(s):
        [] call vgm_g_fnc_missions_getHubSpawnPos;
 */

private _pos = getMarkerPos "vgm_shared_hub_respawn";
private _safePos = _pos findEmptyPosition [1, 15, "CAManBase"];

if (_safePos isEqualTo []) exitWith {
    _pos
};

_safePos

