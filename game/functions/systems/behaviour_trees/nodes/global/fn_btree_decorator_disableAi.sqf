#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_disableAi.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-10-25
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Disables specific parts of the AI when entered, and restores them when exited.

        Purely a wrapper - will always be entered successfully, and returns the result of the child node.

        NOTE: If a unit is added to the group while inside this decorator, it may not have the AI correctly disabled until this decorator is re-entered.

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

_decorator set ["name", "Disable AI"];

_decorator set ["saveUnitAiState", {
    params ["_state", "_unit"];

    private _aiFeatures = [_node] call vgm_g_fnc_btree_getNodeParams getOrDefault ["features", []];
    private _unitStates = _state getOrDefault ["originalUnitStates", createHashMap, true];
    _unitStates set [hashValue _unit, _aiFeatures apply {[_x, _unit checkAIFeature _x]}];
}];

_decorator set ["restoreUnitAiState", {
    params ["_state", "_unit"];

    private _unitStates = _state getOrDefault ["originalUnitStates", createHashMap, true];
    private _featureStates = _unitStates getOrDefault [hashValue _unit, []];

    {
        _x params ["_feature", "_enable"];
        _unit enableAIFeature [_feature, _enable];
    } forEach _featureStates;
}];

_decorator set ["onEnter", {
    params ["_node", "_state"];

    private _units = units _extern_group;
    private _aiFeatures = [_node] call vgm_g_fnc_btree_getNodeParams getOrDefault ["features", []];

    {
        private _unit = _x;
        [_state, _unit] call (_node get "saveUnitAiState");
        {
            _unit enableAIFeature [_x, false];
        } forEach _aiFeatures;
    } forEach _units;

    // Execute the child
    [RESULT_RUNNING]
}];

_decorator set ["onExit", {
    params ["_node", "_state", "_result"];

    private _units = units _extern_group;

    {
        [_state, _unit] call (_node get "restoreUnitAiState");
    } forEach _units;
}];


_decorator
