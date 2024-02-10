/*
    File: fn_btree_decorator_updateKnowledgeService.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-10
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Applies custom suppression to the AI.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [vgm_g_fnc_btree_decorator_suppressionService, [], [_node]] call vgm_g_fnc_btree_compileTree
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basicService;

_decorator set ["name", "apply suppression"];

_decorator set ["onTreeAssigned", {
    params ["_group", "_blackboard"];

    private _suppressionCode = {
        params ["_unit", "_distance", "_shooter"];
        // TODO - replace with weapon's suppression value
        [_unit, 0.1, _shooter] call vgm_g_fnc_suppression_add;
    };

    _group setVariable [
        "vgm_l_btree_suppressionHandler",
        [_group, "Suppressed", _suppressionCode] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup
    ];
}];

_decorator set ["onTreeUnassigned", {
    params ["_group", "_blackboard"];

    [
        _group,
        _group getVariable "vgm_l_btree_suppressionHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;
}];

_decorator set ["onTick", {
    params ["_node", "_state"];

    {
        [_x] call vgm_g_fnc_suppression_decay;
    } forEach units _extern_group;

}];

_decorator
