/*
    File: fn_behaviour_vehicle_assign.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Vehicle assign' behaviour - Assigns the squad a vehicle to use.
        Squads will automatically man assigned static weapons.
    
    Parameter(s):
        _group - Group to run behaviour on
		_vehicle - Vehicle to use.
    
    Returns:
        Behaviour executed successfully [BOOL]
    
    Example(s):
		[_group, _nearbyStatic] call para_g_fnc_behaviour_vehicle_assign
*/

params ["_group", "_vehicle"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Vehicle Assign Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

// Checks if there is an active claim on the vehicle has expired.
private _vehicleIsClaimed = ([_vehicle, "claimedBy", [grpNull, 0]] call para_g_fnc_ai_public_var_get) select 1 > serverTime;

//Don't claim it if it's already claimed by another squad.
if (_vehicleIsClaimed) exitWith { 
    false 
};

private _assignedVehicles = _group getVariable ["behaviourAssignedVehicles", []];

//Only assign the vehicle if we've got the men to crew it, and we aren't already assigned.
if !(_vehicle in _assignedVehicles) then {
	//Update the groups knowledge.
	_assignedVehicles pushBack _vehicle;
    
    //Tell the server and other squads we're claiming the static for the next 10 seconds.
    [_vehicle, "claimedBy", [_group, serverTime + 10]] call para_g_fnc_ai_public_var_set;
};

_group setVariable ["behaviourAssignedVehicles", _assignedVehicles];