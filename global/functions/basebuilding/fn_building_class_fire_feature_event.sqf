/*
	File: fn_building_class_fire_feature_event.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Fires a specific callback for all features on class of building.
		Using `building_fire_feature_event` is preferable where possible, as it's more efficient.
	
	Parameter(s):
		_buildingClass - Class name of building
		_eventName - Name of the callback to fire
		_arguments - Arguments to pass to the callback
	
	Returns:
		Results of firing the event on all features
	
	Example(s):
		["Land_vn_medic_tent", "canPlaceBuilding", [_object]] call para_g_fnc_building_fire_feature_event
*/
params ["_buildingClass", "_eventName", "_arguments"];

private _featureConfigs = [_buildingClass] call para_g_fnc_building_class_get_feature_configs;

_featureConfigs apply {
	_arguments call (missionNamespace getVariable [getText (_x >> _eventName), {}]);
}