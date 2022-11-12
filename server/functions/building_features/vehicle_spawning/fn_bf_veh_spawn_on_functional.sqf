/*
    File: fn_bf_veh_spawn_on_functional.sqf
    Author:  Savage Game Design
    Public: No

    Description:
		Called when a vehicle spawn starts functioning. Allows it to operate as a master arm station. Does not provide vehicle supplies.

    Parameter(s):
		_building - Building that became functional [OBJECT]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        See building features config
*/
params ["_building"];

private _buildingObject = (_building getVariable "para_g_objects") select 0;

vn_fnc_masterarm_action_objects pushBackUnique _buildingObject;
