/*
    File: fn_btree_decorator_hasFollowableNearbyTracks.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-03-06
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Checks for nearby tracks from the tracking system.

        Fails if there's no nearby tracks.
        Otherwise propagates the child node's return value.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_fetchNearbyDangerReportAsInvestigationPoint;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "has followable nearby tracks?"];
_decorator set ["condition", {
    params ["_node", "_state"];

    // Allows the AI to resume tracking, and also optimises if this node is used multiple times in the same tree.
    private _currentTrack = _extern_blackboard getOrDefault ["tracking_currentTrack", createHashMap];
    private _groupLeader = leader _extern_group;

    if (_currentTrack getOrDefault ["pos", [-1000, -1000]] distance2D getPos _groupLeader < 100) exitWith {
        true
    };

    private _nearbyTracks = [_extern_group] call vgm_g_fnc_btree_tracking_findNearbyTrails;

    if (_nearbyTracks isEqualTo []) exitWith { false };

    private _nextTrack = _nearbyTracks # -1 # 0;

	// Only accept newer tracks as interesting, to prevent getting stuck going in circles or infinitely tracking.
    if (_nextTrack get "time" <= _currentTrack getOrDefault ["time", 0]) exitWith {
        false
    };

    _extern_blackboard set ["tracking_currentTrack", _nextTrack];

    true
}];


_decorator
