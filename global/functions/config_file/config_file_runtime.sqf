/*
    File: config_file_runtime.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Retrieves the root config for Paradigm, resolving if it's an addon or in the mission at runtime.
    
    Parameter(s):
		None
    
    Returns:
		Root Config [CONFIG]
    
    Example(s):
		call para_g_fnc_config_file
*/

paraConfigFile = [missionConfigFile, configFile] select (isClass (configFile >> "CfgPatches" >> "sgd_paradigm"));

paraConfigFile