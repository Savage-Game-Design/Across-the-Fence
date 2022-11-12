/*
    File: fn_building_system_init.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Initalises the building system
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
		[] call para_s_fnc_building_system_init
*/

para_g_max_base_radius = 250;
publicVariable "para_g_max_base_radius";

// init buildables type arrays
private _buildables_config = (_gamemode_config >> "buildables");
private _classes = "isClass _x" configClasses (_buildables_config);
private _types = [];
{
	private _buildable_type = getText(_x >> "type");
	if !(_buildable_type in _types) then
	{
		_types pushBack _buildable_type;
		missionNamespace setVariable [format["para_buildings_%1",_buildable_type],[]];
	};
} forEach _classes;

//All bases
para_g_bases = [];
//All buildings
para_l_buildings = [];
//Wreck recovery buildings
para_s_bf_wreck_recovery_buildings = [];

//Load any saved bases.
[] call para_s_fnc_basebuilding_load;