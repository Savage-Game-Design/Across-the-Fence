/*
    File: fn_behaviour_vehicle_unassign.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Vehicle unassign' behaviour - Has the squad leave a vehicle
    
    Parameter(s):
        _group - Group to run behaviour on
        _vehicle - Vehicle that's currently crewed.
    
    Returns:
        Behaviour executed successfully [BOOL]
    
    Example(s):
		[_group, _nearbyStatic] call para_g_fnc_behaviour_vehicle_unassign
*/

params ["_group", "_vehicle"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Vehicle Unassign Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _assignedVehicles = _group getVariable ["behaviourAssignedVehicles", []];

private _assignedUnits = units _group select {assignedVehicle _x isEqualTo _vehicle};

{
    unassignVehicle _x;
    [_x] orderGetIn false;
} forEach _assignedUnits;

//If we've claimed the vehicle, remove it.
if ([_vehicle, "claimedBy", [grpNull, 0]] call para_g_fnc_ai_public_var_get select 0 isEqualTo _group) then {
    [_vehicle, "claimedBy", [grpNull, 0]] call para_g_fnc_ai_public_var_set;
};

_group setVariable ["behaviourAssignedVehicles", _assignedVehicles - [_vehicle]];
_group setVariable ["behaviourUnitsAssignedVehicles", units _group select {!isNull assignedVehicle _x}];