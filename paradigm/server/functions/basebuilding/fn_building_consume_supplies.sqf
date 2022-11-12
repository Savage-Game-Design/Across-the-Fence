/*
    File: fn_building_consume_supplies.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Consumes supplies from a building, if possible.
    
    Parameter(s):
        _building - Building to use [OBJECT]
		_quantity - Number of supplies to consume. Negative number to add. [NUMBER]
		_force - Consume supplies, even if there aren't enough. [BOOLEAN]
    
    Returns:
		True if building had enough supplies, false otherwise [BOOLEAN]
    
    Example(s):
*/
params ["_building", "_quantity", ["_force", false]];

private _supplySource = _building getVariable "para_g_current_supply_source";

if (isNil "_supplySource") exitWith {
	["ERROR", format ["Attempting to take supplies from building %1 that doesn't have a supply source", typeOf _building]] call para_g_fnc_log;
	false;
};

private _currentSupplies = _supplySource getVariable "para_g_current_supplies";

private _enoughSupplies = _currentSupplies > _quantity;
if (_enoughSupplies || _force) then {
	_supplySource setVariable [
		"para_g_current_supplies", 
		(_currentSupplies - _quantity) max 0 min (_supplySource getVariable "para_g_supply_capacity"), 
		true
	];

	[
		_building, 
		"onSuppliesChanged", 
		[_building, _supplySource getVariable "para_g_current_supplies"]
	] call para_g_fnc_building_fire_feature_event;

	[_building] call para_s_fnc_building_functional_update;
};


_enoughSupplies