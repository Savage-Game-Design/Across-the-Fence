/*
    File: fn_btree_decorator_updateKnowledgeService.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-10
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Updates the AI's knowledge from the external environment.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basicService;

_decorator set ["name", "update knowledge"];

_decorator set ["onTreeAssigned", {
    params ["_group", "_blackboard"];

    // Record danger events
    private _suppressedHandler = [_group, "Suppressed", {
        params ["_unit"];
        private _blackboard = group _unit getVariable "vgm_l_btree_state" get "blackboard";
        _blackboard set ["lastDangerEvent", serverTime];
    }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
    _group setVariable ["vgm_l_btree_suppressedDangerHandler", _suppressedHandler];

    private _hitHandler = [_group, "Hit", {
        params ["_unit"];
        private _blackboard = group _unit getVariable "vgm_l_btree_state" get "blackboard";
        _blackboard set ["lastDangerEvent", serverTime];
    }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
    _group setVariable ["vgm_l_btree_hitDangerHandler", _hitHandler];
}];

_decorator set ["onTreeUnassigned", {
    params ["_group", "_blackboard"];

    [
        _group,
        _group getVariable "vgm_l_btree_suppressedDangerHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;

    [
        _group,
        _group getVariable "vgm_l_btree_hitDangerHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;
}];

_decorator set ["onTick", {
    //params ["_node", "_state"];
}];

_decorator
