#include "..\..\behaviour_trees.inc"
#include "..\..\compiler\definitions.inc"
/*
    File: fn_btree_tree_enemyAI.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-10-25
    Public: No

    Description:
        Full behaviour tree for the standard enemy AI.

        Must be compiled before use.

    Parameter(s):
        None

    Returns:
        Behaviour tree specification [ARRAY]

    Example(s):
        private _tree = [[] call vgm_g_fnc_btree_tree_enemyAI] call vgm_g_fnc_btree_compileTree;
        [_group, _tree] call vgm_g_fnc_btree_setTreeLocal;
 */

[DECORATOR(updateKnowledgeService), [], [
[DECORATOR(suppressionService), [], [
[DECORATOR(disableAi), [["features", ["AUTOCOMBAT"]]], [
[DECORATOR(loopInfinitely), [], [
    [SELECTOR, [], [
        [DECORATOR(fetchNearbyDangerReportAsInvestigationPoint), [["abortLowerPriority", true]], [
            [ACTION(moveToInvestigationPoint), []]
        ]],
        [DECORATOR(hasOrders), [["order", "DEFEND"], ["abortLowerPriority", true]], [
            [ACTION(patrolArea), [["center", { _extern_blackboard get "currentOrderPosition" }], ["radius", 10]]]
        ]],
        [DECORATOR(hasNearbyTracks), [["abortLowerPriority", true]], [
            [ACTION(followTracks), []]
        ]],
        [ACTION(patrolArea), []]
    ]]
]]
]]
]]
]]
