/*
    File: fn_resupplybuilding.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Ressuply building.
        [!:warning] This function should not be called directly!

    Parameter(s):
		  _object - Object [Object, defaults to objNull]
		  _resupplyType - Item to resupply with, can either be "CRATE" or "SANDBAG" [String, defaults to "CRATE"]


    Returns: nothing

    Example(s): none
*/

params [
	["_object",objNull,[objNull]],		// 0 : OBJECT
	["_resupplyType", "CRATE", [""]]
];

//THIS IS A REHANDLER FUNCTION
//It can only be called from rehandler, as it relies on having _player defined.

//_object is the object being looked at
//_building is the building namespace/object, which has one or more child objects.
private _building = _object getVariable ["para_g_building", objNull];

if (isNull _building) exitWith {diag_log "VN MikeForce: Attempting to resupply null object or object with no building"};

if !(_building getVariable ["para_g_building_constructed", false]) exitWith {diag_log "Paradigm: Attempting to resupply a building that hasn't been built"};

private _buildingType = _building getVariable ["para_g_buildclass", ""];

if (_buildingType == "") exitWith {diag_log format ["VN MikeForce: Object %1 cannot be resupplied, no build class", _object]};

private _supplySource = _building getVariable ["para_g_current_supply_source", objNull];

if (isNull _supplySource) exitWith {
	diag_log format ["VN MikeForce: Building with object %1 has no supply source", _building getVariable "para_s_building_id"];
};

private _config = (missionConfigFile >> "gamemode");
private _buildablesConfig = (_config >> "buildables");
private _buildingConfig = (_buildablesConfig >> _buildingType);

private _supplyType = getText (_buildingConfig >> "resupply");

private _supplies = 0;

if (_resupplyType == "CRATE") then {
	private _validSupplyConfigs = "getText (_x >> 'supplyType') == _supplyType" configClasses (missionConfigFile >> "gamemode" >> "supplydrops" >> "construction");
	private _validClasses = _validSupplyConfigs apply {getText (_x >> "className")};
	//Use crates near to the object being looked at
	private _nearbySupplies = _object nearEntities [_validClasses, 20] select {isNull attachedTo _x};
	if (_nearbySupplies isEqualTo []) exitWith {};
	private _selectedCrate = _nearbySupplies select 0;
	//This should be safe, because the above logic should guarantee the two arrays match, and that the type is in _validClasses.
	private _config = _validSupplyConfigs select (_validClasses find typeOf _selectedCrate);

	_supplies = _supplies + getNumber (_config >> "supplyQuantity");
	deleteVehicle (_nearbySupplies select 0);
};

//Sandbags only offer building supplies
if (_resupplyType == "SANDBAG" && _supplyType == "BuildingSupplies") then {
	_sand_bag_class = "vn_prop_fort_mag";
	if (_sand_bag_class in magazines _player) then {
		_supplies = _supplies + (["building_sandbag_value", 500] call BIS_fnc_getParamValue);
		[_player, _sand_bag_class] remoteExec ["removeMagazine", _player];
	};
};

//No supplies, no point continuing execution.
if (_supplies == 0) exitWith {};

[_building, -_supplies, true] call para_s_fnc_building_consume_supplies;

_supplySource getVariable "para_g_current_supplies"
