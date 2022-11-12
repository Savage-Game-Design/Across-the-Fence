/*
    File: bf_veh_spawn_add_spawn_actions.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Adds vehicle spawning actions to an object, based on the building config.

    Parameter(s):
		_buildingObject - Object to add actions to [OBJECT]

    Returns:
		None

    Example(s):
		[_object] remoteExecCall ["para_c_fnc_bf_veh_spawn_add_spawn_actions", 2];
*/

params ["_buildingObject"];

//This *must* be defined, as the server will only use valid buildings.
private _building = _buildingObject getVariable "para_g_building";
private _buildingConfig = [_building] call para_g_fnc_get_building_config;

//TODO - Fill in when building sides are implemented.
private _buildingSide = "";
private _vehicleCategory = "getText(_x >> 'side') in ['',_buildingSide]" configClasses (_buildingConfig >> "features" >> "vehicle_spawning" >> "vehicle_class");

private _fnc_vehicleSpawnActionFromConfig = {
	params ["_category", "_vehicleConfig"];
	private _vehicle = configName _vehicleConfig;
	private _name = localize getText (_vehicleConfig >> "name");
	private _icon = getText (_vehicleConfig >> "icon");

	createHashMapFromArray [
		["iconPath", _icon],
		["functionArguments", [_buildingObject, _vehicle, _category]],
		["function", "para_c_fnc_bf_veh_spawn_request_vehicle_spawn"],
		["text", getText (configFile >> "CfgVehicles" >> configName _vehicleConfig >> "displayName")]
	]
};

{
	private _category = configName _x;
	private _submenuActions = "true" configClasses (_x) apply {[_category, _x] call _fnc_vehicleSpawnActionFromConfig};
	private _name = localize getText (_x >> "name");
	private _icon = getText (_x >> "icon");
	private _submenus = createHashMapFromArray [
		["iconPath", _icon],
		["submenuActions", _submenuActions],
		["text", _name]
	];

	[
		_buildingObject,
		_submenus
	] call para_c_fnc_wheel_menu_add_obj_action;
} forEach _vehicleCategory;
