/*
    File: fn_supply_source_create.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Makes an existing namespace, object, or anything `setVariable` is valid on into a supply source.
        This **must be a networked entity**, no using local namespaces.
    
    Parameter(s):
        _supplySource - Namespace to turn into a supply source. Usually an object. [OBJECT]
        _initialSize - Initial size of the source [NUMBER]
		_initialSupplies - Number of supplies to populate the source with [NUMBER]
    
    Returns:
        The created supply source [NAMESPACE]
    
    Example(s):
		[_myBuilding, 600, 10] call para_s_fnc_supply_source_create
*/

params ["_supplySource", "_initialSize", ["_initialSupplies", 0]];

_supplySource setVariable ["para_g_supply_capacity", _initialSize, true];
_supplySource setVariable ["para_g_current_supplies", _initialSupplies, true];
_supplySource setVariable ["para_g_supply_consumption_rate", 0, true];
_supplySource setVariable ["para_g_supply_buildings", [], true];

_supplySource