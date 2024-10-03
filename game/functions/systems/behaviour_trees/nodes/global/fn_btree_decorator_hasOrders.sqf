#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_hasOrders.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-10-03
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Checks if the unit has orders of the specific type assigned.

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

_decorator set ["name", "Has orders"];
_decorator set ["condition", {
    params ["_node", "_state"];

    private _order = _extern_group getVariable "vgm_g_order";

    if (isNil "_order") exitWith { false };

    private _currentParams = [_node, _state] call vgm_g_fnc_btree_getNodeParams;
    private _desiredOrder = _currentParams getOrDefault ["order", "NO ORDER SET"];

    if (_order getOrDefault ["type", ""] isEqualTo  _desiredOrder) exitWith {
        _state set ["currentOrder", _order];
        true
    };

    false
}];

_decorator set ["onEnter", {
    params ["_node", "_state"];

    _state set ["oldOrder", _extern_blackboard get "currentOrder"];
    _state set ["oldOrderPosition", _extern_blackboard get "currentOrderPosition"];

	// This should always be set, else we can't enter the node.
    private _currentOrder = _state get "currentOrder";
    _extern_blackboard set ["currentOrder", _currentOrder];
    _extern_blackboard set ["currentOrderPosition", _currentOrder get "pos"];

    // Execute the child
    [RESULT_RUNNING]
}];

_decorator set ["onExit", {
    params ["_node", "_state", "_result"];

    _extern_blackboard set ["currentOrder", _state get "oldOrder"];
    _extern_blackboard set ["currentOrderPosition", _state get "oldOrderPosition"];
}];


_decorator
