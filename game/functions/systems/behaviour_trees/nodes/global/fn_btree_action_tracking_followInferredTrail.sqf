#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_followInferredTrail.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Action node.

        Infers where a trail leads, based on the last track visited, and follows it for a specific distance.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_followInferredTrail;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "follow inferred trail"];

_action set ["onEnter", {
    params ["_node", "_state"];

    private _lastTrack = _extern_blackboard getOrDefault ["tracking_lastTrack", createHashMap];
    // Vector pointing from the last track to the track that came before it.
    private _lastTrackPrevTrackVector = _lastTrack get "prevTrackVector";

    if (isNil "_lastTrackPrevTrackVector") exitWith {
        [ RESULT_FAILED ]
    };

    private _nodeParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    // Cache these values from nodeParams, so we can use sensible defaults. _state is also cheaper to access regularly.
    private _distance = _nodeParams getOrDefaultCall ["distance", { random [0, 50, 100] }];

    private _directionVector = vectorNormalized (_lastTrackPrevTrackVector vectorMultiply -1);
    private _exactDestination = _lastTrack get "pos" vectorAdd (_directionVector vectorMultiply _distance);
    // Set height to 0 so we're always level with terrain.
    _exactDestination set [2, 0];

    private _safeLocation = _exactDestination findEmptyPosition [0, 25];
    private _destination = [_safeLocation, _exactDestination] select (_safeLocation isEqualTo []);

    _state set ["destination", _destination];

    [_extern_group, _destination, "NORMAL", 5] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if !(_isAtDestination) exitWith { [ RESULT_RUNNING ] };

    [ RESULT_SUCCEEDED ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
