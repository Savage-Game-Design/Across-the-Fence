#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_timeLimit.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-03-06
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Aborts the subtree below it, if the time limit is exceeded.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_timeLimit;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "time limit"];
// Abort the tree below it by default, unless a parameter says otherwise.
_decorator set ["abortChildrenOnConditionFailure", _params getOrDefault ["abortChildrenOnConditionFailure", true]];
_decorator set ["condition", {
    params ["_node", "_state"];

    private _currentParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    private _maxDuration = _currentParams getOrDefault ["maxDuration", 0];

    if (_maxDuration <= 0) exitWith {
        false
    };

    private _currentTime = time;
    private _startTime = _state getOrDefault ["startTime", _currentTime];
    if (_currentTime > _startTime + _maxDuration) exitWith {
        false
    };

    true
}];

_decorator set ["onEnter", {
    params ["_node", "_state"];

    _state set ["startTime", time];

    // Execute the child
    [RESULT_RUNNING]
}];

_decorator
