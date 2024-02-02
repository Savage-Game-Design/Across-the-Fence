#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_tickGroup.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Ticks the behaviour tree assigned to the group.

    Parameter(s):
        _group - Group to tick. Must be assigned a behaviour tree with vgm_g_fnc_btree_setTree [GROUP]

    Returns:
        Nothing

    Example(s):
        [group cursorObject] call vgm_g_fnc_btree_tickGroup;
 */


params ["_group"];

private _tree = _group getVariable "vgm_l_btree_current";

if (isNil "_tree") exitWith {};

// These variables are available for ALL CALLED FUNCTIONS.
// I.e - It should be safe to use them in any non-setup btree functions (actions, etc)
// However - be careful, as changing them could break execution.
private _extern_group = _group;
private _extern_btreeState = _group getVariable "vgm_l_btree_state";
private _extern_stack = _extern_btreeState get "stack";
private _extern_blackboard = _extern_btreeState get "blackboard";

// Run current node by default
private _nextAction = ACTION_RUN_CURRENT_NODE;
private _nextActionParams = [];

// If no current node, start tree execution from the top.
if (count _extern_stack == 0) then {
    _nextAction = ACTION_ENTER_NODE;
    _nextActionParams = [_tree];
};

[format ["Ticking behaviour tree for group %1 at %2", str _group, serverTime]] call vgm_g_fnc_btree_log;

{
    // Check if there's any conditions on the current path that can cause us to abort.
    private _frame = _x;
    private _node = _frame get "node";
    private _state = _frame get "state";

    if (_frame get "isInterruptNode" && {[_node, _state] call (_node get "condition") isEqualTo RESULT_FAILED} ) exitWith {
        [_forEachIndex] call vgm_g_fnc_btree_unwindStackUpToIndex;
        _nextAction = ACTION_RETURN_TO_PARENT;
        _nextActionParams = [RESULT_FAILED];
    };

    // Check if there's any higher priority nodes registered, that need us to abort and switch to them.
    private _newChildToRunIndex = _frame getOrDefault ["higherPriorityNodes", []] findIf {
        private _child = _node get "children" select _x;
        [_child get "node"] call (_child get "condition")
    };

    if (_newChildToRunIndex > -1) exitWith {
        [_forEachIndex] call vgm_g_fnc_btree_unwindStackUpToIndex;
        _nextAction = ACTION_RUN_CHILD;
        _nextActionParams = [_frame get "higherPriorityNodes" select _newChildToRunIndex];
    };

    if (_frame get "isServiceNode") then {
        [_node, _state] call (_node get "onTick");
    };

} forEach _extern_stack;

// Each action can return the next action that needs executing.
// Actions can theoretically be any function, but only the constants in behaviour_trees.inc should be used.

// Note:
// Effectively implements tail recursion, with the possibility of suspending between actions in the future.

while {_nextAction isNotEqualTo {}} do {
    private _result = _nextActionParams call _nextAction;

    _nextActionParams = _result # 0;
    _nextAction = _result # 1;
};
