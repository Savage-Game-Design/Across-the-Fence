/*
 * File: fn_player_within_radius.sqf
 * Author: Spoffy
 * Description:
 *    Tests if a player is within a given radius of a position
 *    Implement as a function, so we can optimise it easily later.
 * Params:
 *    _pos - Center position
 * Returns:
 *    Boolean - True if a player is within the given radius
 * Example Usage:
 *    [[0,0,0], 100] call vn_mf_fnc_player_within_radius
 */

params ["_pos", "_radius"];

(playableUnits findIf {_x distance2D _pos < _radius} > -1)