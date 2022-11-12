/*
    File: fn_behaviour_is_valid_target.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Reports if a target is valid for a squad to engage
    
    Parameter(s):
		_group - Group to check target validity against [GROUP]
		_target - Target object [OBJECT]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [_group, assignedTarget leader _group] call para_g_fnc_behaviour_is_valid_target
*/

params ["_group", "_target"];

if (isNull _target || ! (alive _target) || (vehicle _target isKindOf "air") || (leader _group distance2D _target > 1000)) exitWith {false};

true