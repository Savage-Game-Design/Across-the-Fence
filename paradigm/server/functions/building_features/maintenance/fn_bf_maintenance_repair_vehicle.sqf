/*
    File: fn_bf_maintenance_repair_vehicle.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Repairs a vehicle.
    
    Parameter(s):
        _vehicle - Vehicle to repair. [OBJECT]
		_repairObject - Object that's part of the repair building [NAMESPACE]
    
    Returns:
		None
    
    Example(s):
		[vehicles # 0] call para_s_fnc_bf_maintenance_repair_vehicle;
*/

params ["_vehicle", "_repairObject"];

//Prevent any weird exploits, where a person could be repaired.
//Unlikely to happen, but you never know.
if (_vehicle isKindOf "Man") exitWith {
	diag_log format ["Paradigm: Warning: Attempted to repair a man: %1", _vehicle];
};

if (_vehicle distance _repairObject > 15) exitWith 
{
	//TODO - Hint to the driver of the vehicle they're too far away.
	//Shouldn't happen in practice, as addAction has smaller radius.
};

private _building = _repairObject getVariable ["para_g_building", objNull];

if (isNull _building) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to repair from object with no building %1", _repairObject];
};

if !([_building] call para_g_fnc_building_is_functional) exitWith
{
	["BuildingNonFunctional", []] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];
};

private _config = [_building] call para_g_fnc_get_building_config;
if (getNumber (_config >> "features" >> "maintenance" >> "canRepair") == 0) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to repair from building with no repair facilities: %1", configName _config];
};

if (isNil "para_s_bf_repair_main_damage_cost") then 
{
	para_s_bf_maintenance_main_damage_cost = 100;
	para_s_bf_maintenance_hitPoint_damage_cost = 5;
};

private _hitPointDamages = getAllHitPointsDamage _vehicle;
private _totalHitPointDamage = 0;
{
	_totalHitPointDamage = _totalHitPointDamage + _x;
} forEach (_hitPointDamages # 2);

private _overallDamage = damage _vehicle;

private _totalCost = _overallDamage * para_s_bf_maintenance_main_damage_cost + _totalHitPointDamage * para_s_bf_maintenance_hitPoint_damage_cost;

private _usedSupplies = [_building, _totalCost] call para_s_fnc_building_consume_supplies;

if (_usedSupplies) then 
{
	_vehicle setDamage 0;
	["VehicleRepaired", [_totalCost toFixed 1]] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];
}
else 
{
	["InsufficientResources", []] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];  
};