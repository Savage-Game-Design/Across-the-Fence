#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_tracking_findNearbyTracks.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-03-06
    Public: Yes

    Description:
        Action node.

        Checks for nearby tracks from the tracking system, and stores them in the backboard.

        Succeeds if nearby tracks are found.
        Fails if there's no nearby tracks.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_action_tracking_findNearbyTracks
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "find nearby tracks"];
_action set ["onEnter", {
    params ["_node", "_state"];

    // Allows the AI to resume tracking, and also optimises if this node is used multiple times in the same tree.
    private _currentTrack = _extern_blackboard getOrDefault ["tracking_currentTrack", createHashMap];
    private _groupLeader = leader _extern_group;

    if (_currentTrack getOrDefault ["pos", [-1000, -1000]] distance2D getPos _groupLeader < 100) exitWith {
        [ RESULT_SUCCEEDED ]
    };

    private _nearbyTracks = [_extern_group] call vgm_g_fnc_btree_tracking_findNearbyTrails;

    if (_nearbyTracks isEqualTo []) exitWith { [ RESULT_FAILED ] };

    private _nextTrack = _nearbyTracks # -1 # 0;

    // Prevent the behaviour tree repeatedly looping due to re-discovering old tracks.
    if (_nextTrack get "time" <= _currentTrack getOrDefault ["time", 0]) exitWith {
        [ RESULT_FAILED ]
    };

    _extern_blackboard set ["tracking_currentTrack", _nextTrack];

    [ RESULT_SUCCEEDED ]
}];


_action
