/*
    File: fn_base_serialize.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Serializes a base into an array for saving
    
    Parameter(s):
		_base - Base to serialize [NAMESPACE]
    
    Returns:
		Serialized base [ARRAY]
    
    Example(s):
		[_base] call para_s_fnc_base_serialize;
*/

params ["_base"];

[
	//Version number. First is breaking changes, second is non-breaking.
	"1.0",
	//Base id
	_base getVariable "para_g_base_id",
	//Base name
	_base getVariable "para_g_base_name",
	//Base radius
	_base getVariable "para_g_base_radius",
	//Base supply values
	_base getVariable "para_g_supply_source" getVariable "para_g_current_supplies",
	//Base position
	getPosASL _base apply {_x toFixed 3}
]