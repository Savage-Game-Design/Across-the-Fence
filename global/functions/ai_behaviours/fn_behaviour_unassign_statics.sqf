/*
    File: fn_behaviour_unassign_statics.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Unassign statics' behaviour. Unassigns any statics that have been assigned to the group.
    
    Parameter(s):
        _group - Group to run the behaviour on.
    
    Returns:
        Behaviour executed successfully [BOOL]
    
    Example(s):
        _group call para_g_fnc_behaviour_unassign_statics
*/

params ["_group"];

private _assignedStatics = _group getVariable ["behaviourAssignedVehicles", []] select {_x isKindOf "StaticWeapon"};
{
    [_group, _x] call para_g_fnc_behaviour_vehicle_unassign;
} forEach _assignedStatics