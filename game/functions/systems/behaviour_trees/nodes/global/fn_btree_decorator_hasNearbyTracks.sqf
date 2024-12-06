/*
    File: fn_btree_decorator_hasNearbyTracks.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-12-06
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

_decorator set ["name", "Has nearby tracks?"];
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

    _extern_blackboard set ["tracking_currentTrack", _nearbyTracks # -1 # 0];

    true
}];


_decorator
