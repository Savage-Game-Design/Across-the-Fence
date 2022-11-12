/*
	File: fn_building_class_get_feature_configs.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Gets the configs for the features attached to a particular building.
	
	Parameter(s):
		_buildingClass - Class name of building
	
	Returns:
		Configs of all features attached to that building [ARRAY]
	
	Example(s):
		["Land_vn_medic_tent"] call para_g_fnc_building_class_get_feature_configs
*/
params ["_buildingClass"];

private _featuresConfig = (missionConfigFile >> "gamemode" >> "buildables" >> _buildingClass >> "features");
private _features = "true" configClasses _featuresConfig apply {configName _x};

//Select feature configs from both config file and mission config file.
private _featureConfigs = 
	(_features apply {configFile >> "CfgBuildingFeatures" >> _x})
	+ (_features apply {missionConfigFile >> "CfgBuildingFeatures" >> _x})
	select {isClass _x};

_featureConfigs