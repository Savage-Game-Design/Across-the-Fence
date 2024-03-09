#include "..\..\behaviour_trees.inc"

/*
	File: fn_btree_action_followTracks.sqf
	Author:  Savage Game Design
	Public: No

	Description:
        Action node.

		Makes the group patrol around a point.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_patrolArea;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "follow tracks"];

_action set ["getNextTrack", {

    private _currentTrack = _extern_blackboard get ["tracking_currentTrack", createHashMap];

    if ("nextTrack" in _currentTrack) exitWith {
        _currentTrack get "nextTrack"
    };

    private _nearbyTracks = [
        _extern_group getVariable "vgm_g_missionId",
        getPos leader _extern_group,
        75
    ] call vgm_g_fnc_tracking_nearbyTracks;

    private _currentTrackTime = _currentTrack getOrDefault ["time", 0];
    private _moreRecentTrackIndex = _nearbyTracks findIf {_x get "time" > _currentTrackTime};

    if (_moreRecentTrackIndex == -1) exitWith {};

    _nearbyTracks # _moreRecentTrackIndex
}];

_action set ["onEnter", {
    params ["_node", "_state"];

    if !("tracking_currentTrack" in _extern_blackboard) exitWith {
        [ RESULT_FAILED ]
    };

	private _currentTrack = _extern_blackboard get "tracking_currentTrack";

    [_extern_group, _currentTrack get "pos", "NORMAL", 20] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if (!_isAtDestination) exitWith { [ RESULT_RUNNING ]};

    private _nextTrack = [] call (_node get "getNextTrack");

    if (isNil "_nextTrack") exitWith { [ RESULT_SUCCEEDED ] };

    _extern_blackboard set ["tracking_currentTrack", _nextTrack];
    [_extern_group, _nextTrack get "pos", "NORMAL", 20] call vgm_g_fnc_btree_moveTo_start;
    [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
