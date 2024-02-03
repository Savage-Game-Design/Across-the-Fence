/*
    File: fn_btree_callOnTreeAssignedCallbacks.sqf
    Author: Savage Game Design
    Date: 2024-02-03
    Last Update: 2024-02-03
    Public: No

    Description:
        Nodes can register code to be run when the tree is assigned to a group.
        This allows them to do things like set up event handlers.

        This function runs that code, and makes sure it's tidied up if the group is deleted.

    Parameter(s):
        _group - Group with an assigned tree [GROUP]

    Returns:
        Nothing

    Example(s):
        [_myGroup] call vgm_g_fnc_btree_callOnTreeAssignedCallbacks;
 */

params ["_group"];

private _tree = _group getVariable "vgm_l_btree_current";

{
    [_group] call _x;
} forEach (_tree get "onTreeAssignedCallbacks");

_group setVariable ["vgm_l_btree_onTreeUnassignedEventHandler", _group addEventHandler ["Deleted", {
    params ["_group"];

    [_group] call vgm_g_fnc_btree_callOnTreeUnassignedCallbacks;
}]];
