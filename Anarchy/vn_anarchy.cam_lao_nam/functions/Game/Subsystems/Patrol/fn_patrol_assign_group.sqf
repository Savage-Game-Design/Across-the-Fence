/*
 * File: fn_patrol_assign_group.sqf
 * Author: Spoffy
 * Description:
 *    Assign a group to patrol duty
 * Params:
 *    _group - Group to assign
 * 	  _position - Position to patrol around
 *    _radius - Rough distance from position to patrol around.
 * Returns:
 *    None
 * Example Usage:
 *    [_myGroup, [1,1,1], 100] call vn_mf_fnc_patrol_assign_group;
 */

params ["_group", "_position", "_radius"];

_group setVariable ["patrolCenter", _position];
_group setVariable ["patrolRadius", _radius];

vn_mf_patrols pushBack _group;
