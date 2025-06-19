/*
    File: fn_btree_decorator_updateKnowledgeService.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-04-28
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
        group _unit setVariable ["vgm_l_btree_lastDangerEvent", time];
    }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
    _group setVariable ["vgm_l_btree_updateKnowledge_suppressedHandler", _suppressedHandler];

    private _hitHandler = [_group, "Hit", {
        params ["_unit"];
        group _unit setVariable ["vgm_l_btree_lastDangerEvent", time];
    }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
    _group setVariable ["vgm_l_btree_updateKnowledge_hitHandler", _hitHandler];

    private _firedManHandler = [_group, "FiredMan", {
        params ["_unit"];
        group _unit setVariable ["vgm_l_btree_lastFired", time];
    }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
    _group setVariable ["vgm_l_btree_updateKnowledge_firedManHandler", _firedManHandler];
}];

_decorator set ["onTreeUnassigned", {
    params ["_group", "_blackboard"];

    private _targets = _group getVariable ["vgm_g_ai_targets", []];
    if (_targets isNotEqualTo []) then {
        [
            "vgm_ai_groupTargetsLost",
            [_group, _targets]
        ] call para_g_fnc_event_triggerServer;
    };

    [
        _group,
        _group getVariable "vgm_l_btree_updateKnowledge_suppressedHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;

    [
        _group,
        _group getVariable "vgm_l_btree_updateKnowledge_hitHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;

    [
        _group,
        _group getVariable "vgm_l_btree_updateKnowledge_firedManHandler"
    ] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;
}];

_decorator set ["onTick", {
    params ["_node", "_state"];

    private _combatDuration = _extern_group getVariable ["vgm_l_btree_combatDuration", 15];
    private _combatTimeThreshold = time - _combatDuration;
    private _isInCombat = false;
    private _lastTargets = _extern_group getVariable ["vgm_g_ai_targets", []];
    private _targets = _extern_group targets [true, 0, [], _combatDuration] select {!isPlayer _x || _x getVariable ["vgm_g_stealth_isVisible", false]};

    private _isInCombat =
        (
               _combatTimeThreshold < _extern_group getVariable ["vgm_l_btree_lastDangerEvent", time]
            || _combatTimeThreshold < _extern_group getVariable ["vgm_l_btree_lastFired", time]
        )
        && _targets isNotEqualTo [];

    // It's not permitted to have targets when the squad isn't in combat.
    // This also ensures the 'lostTarget' event fires correctly when the squad leaves combat.
    if (!_isInCombat) then { _targets = []; };

    private _wasInCombat = _extern_group getVariable ["vgm_g_ai_inCombat", false];
    if (_isInCombat isNotEqualTo _wasInCombat) then {
        _extern_group setVariable ["vgm_g_ai_inCombat", _isInCombat, true];
        if (_isInCombat) then {
            [
                "vgm_ai_groupEnteredCombat",
                [_extern_group, _targets]
            ] call para_g_fnc_event_triggerServer;
        };
        // No 'ExitedCombat' event, because we can't guarantee it would fire.
        // For example, the squad being deleted or having its tree unassigned would prevent it firing
        // We can try to handle those situations, but only if it's necessary, as it would be easy to have missed edge cases.
    };

    private _newTargets = _targets - _lastTargets;
    if (_newTargets isNotEqualTo []) then {
        [
            "vgm_ai_groupTargetsEngaged",
            [_extern_group, _newTargets]
        ] call para_g_fnc_event_triggerServer;
    };
    private _lostTargets = _lastTargets - _targets;
    if (_lostTargets isNotEqualTo []) then {
        [
            "vgm_ai_groupTargetsLost",
            [_extern_group, _lostTargets]
        ] call para_g_fnc_event_triggerServer;
    };

    _extern_group setVariable ["vgm_g_ai_targets", _targets, true];
}];

_decorator
