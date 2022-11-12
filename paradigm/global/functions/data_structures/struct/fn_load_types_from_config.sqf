/*
    File: fn_load_structs_from_config.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Loads structs from the struct config
    
    Parameter(s):
		None
    
    Returns:
		List of struct names
    
    Example(s):
		[] call para_g_fnc_load_structs_from_config
*/

private _missionTypesConfig = missionConfigFile >> "structs";
private _addonTypesConfig = configFile >> "structs";

{
	private _config = _x;
	private _typeConfigs = configProperties [_config, "isClass _x"];
	{
		private _typeConfig = _x;
		private _
		//TBC

	} forEach _typeConfigs;

} forEach [_missionTypesConfig, _addonTypesConfig];
