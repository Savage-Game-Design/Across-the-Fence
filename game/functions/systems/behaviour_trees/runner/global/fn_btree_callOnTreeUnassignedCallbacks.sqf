/*
    File: fn_btree_callOnTreeUnssignedCallbacks.sqf
    Author: Savage Game Design
    Date: 2024-02-03
    Last Update: 2024-03-03
    Public: No

    Description:
        Nodes can register code to be run when the tree is unassigned from a group, or the group is deleted.
        This allows them to do things like clean up event handlers.

        This function runs that code.

    Parameter(s):
        _group - Group with an assigned tree [GROUP]
        _blackboard - Blackboard for tree being unassigned [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_myGroup] call vgm_g_fnc_btree_callOnTreeAssignedCallbacks;
 */

params ["_group", "_blackboard"];

private _tree = _group getVariable "vgm_l_btree_current";

{
    [_group, _blackboard] call _x;
} forEach (_tree get "onTreeUnassignedCallbacks");

_group removeEventHandler ["Deleted", _group getVariable "vgm_l_btree_onTreeUnassignedEventHandler"];
