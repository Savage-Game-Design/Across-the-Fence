#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_tracking_followTracks.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Action node.

        Follows a trail left by the tracking system until it ends.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_tracking_followTracks;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "follow tracks"];

_action set ["getNextTrack", {

    private _currentTrack = _extern_blackboard getorDefault ["tracking_currentTrack", createHashMap];
    private _currentTrackPos = _currentTrack get "pos";
    private _nextTrack = _currentTrack get "nextTrack";

    if !(isNil "_nextTrack") exitWith {
        // Find the furthest valid track we can path to.
        while {"nextTrack" in _nextTrack && ((_nextTrack get "nextTrack" get "pos") distance2D _currentTrackPos) < 100} do {
            _nextTrack = _nextTrack get "nextTrack";
        };
        _nextTrack
    };

    private _nearbyTracks = [_extern_group] call vgm_g_fnc_btree_tracking_findNearbyTrails;

    if (_nearbyTracks isEqualTo []) exitWith {};

    private _currentTrackTime = _currentTrack getOrDefault ["time", 0];
    private _latestTrack = _nearbyTracks # -1 # 0;

    // Don't follow an older track, prevents loops, also prevents chasing the current track infinitely.
    if (_latestTrack get "time" > _currentTrackTime ) exitWith {
        _latestTrack
    };

    // Base case - there's nothing nearby to follow
    nil
}];

_action set ["onEnter", {
    params ["_node", "_state"];

    if !("tracking_currentTrack" in _extern_blackboard) exitWith {
        [ RESULT_FAILED ]
    };

    private _currentTrack = _extern_blackboard get "tracking_currentTrack";
    _extern_blackboard deleteAt "tracking_lastTrack";

    // Aware allows the squad to move at normal speeds, and causes them to raise their weapons.
    _extern_group setBehaviourStrong "AWARE";
    [_extern_group, _currentTrack get "pos", "NORMAL", 5] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    private _currentTrack = _extern_blackboard get "tracking_currentTrack";
    private _currentTrackPos = _currentTrack get "pos";

    if !(_isAtDestination || (leader _extern_group distance2D _currentTrackPos < 30)) exitWith { [ RESULT_RUNNING ] };

    private _nextTrack = [] call (_node get "getNextTrack");

    _extern_blackboard set ["tracking_lastTrack", _currentTrack];

    // The _isAtDestination check deliberately omitted, as it makes this script much more resilient.
    // Can potentially exit a little early, as we're not necessarily at the destination yet.
    if (isNil "_nextTrack") exitWith {
        // currentTrack should be unset when a trail is successfully followed to the end.
        // It prevents other btree nodes thinking there's still a track that needs visiting, and infinitely chasing it.
        _extern_blackboard deleteAt "tracking_currentTrack";
        [ RESULT_SUCCEEDED ]
    };

    _extern_blackboard set ["tracking_currentTrack", _nextTrack];
    [_extern_group, _nextTrack get "pos"] call vgm_g_fnc_btree_moveTo_updateDestination;
    [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
