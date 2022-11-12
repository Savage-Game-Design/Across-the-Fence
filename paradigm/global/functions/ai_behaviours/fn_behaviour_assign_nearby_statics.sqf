/*
    File: fn_behaviour_assign_nearby_statics.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Crew nearby statics' behaviour. Tells the units in the squad to enter nearby static weapons.
    
    Parameter(s):
        _group - Group to run the behaviour on
		_pos - Position to center search for static weapons on.
    
    Returns:
        True if behaviour executed successfully [BOOL]
    
    Example(s):
        [_group, [0,0,0]] call para_g_fnc_behaviour_assign_nearby_statics
*/

params ["_group", "_pos"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Crew Nearby Statics Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _unmannedStatics = [_group, _pos] call para_g_fnc_behaviour_get_unclaimed_statics;

{
	[_group, _x] call para_g_fnc_behaviour_vehicle_assign;
} forEach _unmannedStatics;

true
