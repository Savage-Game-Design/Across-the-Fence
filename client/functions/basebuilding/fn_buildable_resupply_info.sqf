/*
    File: fn_buildable_resupply_info.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Returns the number of supply crates needed by the buildable object.

    Parameter(s):
        _building - Buildable object <OBJECT>

    Returns:
        <ARRAY> in format [
	 		Current Build Percentage <NUMBER> (0-1),
			Supply crates Until Functional <NUMBER>,
			Supply crates Until Full <NUMBER>
		]

    Example(s):
        [cursorObject] call para_c_fnc_buildable_resupply_info;
 */

params ["_building"];

private _building = _building getVariable ["para_g_building", _building];
private _supplySource = _building getVariable ["para_g_current_supply_source", objNull];

if (isNull _supplySource) exitWith {[]};

private _supplyCapacity = _supplySource getVariable "para_g_supply_capacity";
private _supplyConsumptionRate = _supplySource getVariable "para_g_supply_consumption_rate";
//Calculate the current supply it has based on how long until it despawns.
private _currentSupplies = _supplySource getVariable "para_g_current_supplies";

private _suppliesUntilFull = (_supplyCapacity - _currentSupplies);
private _percentageFull = (_currentSupplies / _supplyCapacity);
private _lifetime = _currentSupplies / _supplyConsumptionRate;

[_percentageFull, _currentSupplies, _suppliesUntilFull, _lifetime, _supplyCapacity]
