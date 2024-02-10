#include "..\..\behaviour_trees.inc"
#include "..\..\compiler\definitions.inc"
/*
    File: fn_btree_tree_enemyAI.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-10
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

[DECORATOR(updateKnowledgeService), [], [
    [DECORATOR(suppressionService), [], [
        [DECORATOR(loopInfinitely), [], [
            [ACTION(basic), []]
        ]]
    ]]
]]
