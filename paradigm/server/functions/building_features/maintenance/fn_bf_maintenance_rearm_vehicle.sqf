/*
    File: fn_bf_maintenance_repair_vehicle.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Repairs a vehicle.
    
    Parameter(s):
        _vehicle - Vehicle to repair. [OBJECT]
		_rearmObject - Object that's part of the repair building [NAMESPACE]
    
    Returns:
		None
    
    Example(s):
		[vehicles # 0] call para_s_fnc_bf_maintenance_repair_vehicle;
*/

params ["_vehicle", "_rearmObject"];

if (_vehicle distance _rearmObject > 15) exitWith 
{
	//TODO - Hint to the driver of the vehicle they're too far away.
	//Shouldn't happen in practice, as addAction has smaller radius.
};

private _building = _rearmObject getVariable ["para_g_building", objNull];

if (isNull _building) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to rearm from object with no building %1", _rearmObject];
};

if !([_building] call para_g_fnc_building_is_functional) exitWith
{
	["BuildingNonFunctional", []] remoteExec ["para_c_fnc_show_notification", currentPilot _vehicle];
};

private _config = [_building] call para_g_fnc_get_building_config;
if (getNumber (_config >> "features" >> "maintenance" >> "canRearm") == 0) exitWith 
{
	diag_log format ["Paradigm: Warning: Attempted to rearm from building with no rearm facilities: %1", configName _config];
};

if (isNil "para_s_bf_maintenance_bullet_cost") then 
{
	para_s_bf_maintenance_bullet_cost = 0.01;
	para_s_bf_maintenance_grenade_cost = 1;
	para_s_bf_maintenance_rocket_cost = 3;
	para_s_bf_maintenance_missile_cost = 5;
};

private _cfgMagazines = (configFile >> "CfgMagazines");
private _cfgAmmo = (configFile >> "CfgAmmo");

private _fnc_magToCost = {
	params ["_magazine", "_currentCount"];
	private _magConfig = (_cfgMagazines >> _magazine);
	private _ammo = getText (_magConfig >> "ammo");
	private _count = getNumber (_magConfig >> "count");
	private _missingAmmo = _count - _currentCount;
	if (_ammo isKindOf ["BulletCore", _cfgAmmo]) exitWith
	{
		_missingAmmo * para_s_bf_maintenance_bullet_cost
	};
	if (_ammo isKindOf ["RocketCore", _cfgAmmo]) exitWith
	{
		_missingAmmo * para_s_bf_maintenance_rocket_cost
	};
	if (_ammo isKindOf ["GrenadeCore", _cfgAmmo]) exitWith
	{
		_missingAmmo * para_s_bf_maintenance_grenade_cost
	};
	if (_ammo isKindOf ["MissileCore", _cfgAmmo]) exitWith
	{
		_missingAmmo * para_s_bf_maintenance_missile_cost
	};
	_missingAmmo
};

private _totalCost = 0;

{
	_totalCost = _totalCost + ([_x # 0, _x # 2] call _fnc_magToCost);
} forEach (magazinesAllTurrets _vehicle);

private _usedSupplies = [_building, _totalCost] call para_s_fnc_building_consume_supplies;

if (_usedSupplies) then 
{
	[_vehicle, 1] remoteExecCall ["setVehicleAmmo", crew _vehicle];
	["VehicleRearmed", [_totalCost toFixed 1]] remoteExec ["para_c_fnc_show_notification", crew _vehicle];
}
else 
{
	["InsufficientResources", []] remoteExec ["para_c_fnc_show_notification", crew _vehicle];  
};