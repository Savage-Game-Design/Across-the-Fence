/*
    File: fn_bf_maintenance_repair_vehicle.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Repairs a vehicle.
    
    Parameter(s):
        _vehicle - Vehicle to repair. [OBJECT]
		_refuelObject - Object that's part of the repair building [NAMESPACE]
    
    Returns:
		None
    
    Example(s):
		[vehicles # 0] call para_s_fnc_bf_maintenance_repair_vehicle;
*/

params ["_vehicle", "_refuelObject"];

if (_vehicle distance _refuelObject > 15) exitWith 
{
	//TODO - Hint to the driver of the vehicle they're too far away.
	//Shouldn't happen in practice, as addAction has smaller radius.
};

private _building = _refuelObject getVariable ["para_g_building", objNull];

if (isNull _building) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to refuel from object with no building %1", _refuelObject];
};

if !([_building] call para_g_fnc_building_is_functional) exitWith
{
	["BuildingNonFunctional", []] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];
};

private _config = [_building] call para_g_fnc_get_building_config;
if (getNumber (_config >> "features" >> "maintenance" >> "canRefuel") == 0) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to refuel from building with no refuel facilities: %1", configName _config];
};

if (isNil "para_s_bf_maintenance_fuel_cost") then 
{
	para_s_bf_maintenance_fuel_cost = 0.5;
};

private _fuelCapacity = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "fuelCapacity");
private _fuelMissing = _fuelCapacity - (_fuelCapacity * fuel _vehicle);
private _totalCost = _fuelMissing * para_s_bf_maintenance_fuel_cost;

private _usedSupplies = [_building, _totalCost] call para_s_fnc_building_consume_supplies;

if (_usedSupplies) then 
{
	[_vehicle, 1] remoteExec ["setFuel", _vehicle];
	["VehicleRefueled", [_totalCost toFixed 1]] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];
}
else 
{
	["InsufficientResources", []] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];  
};