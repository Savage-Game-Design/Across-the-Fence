/*
    File: fn_handle_light_level_loop.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update: 
    Public: /shrug

    Description:
		used to set camera aperature based on light level

    Parameter(s):
		N/A

    Returns: nothing

    Example(s):
		call vgm_c_fnc_handle_light_level_loop;
		
*/

[] spawn
{
	while {true} do
	{
		uiSleep 0.5;
		[] call para_c_fnc_set_aperture_based_on_light_level;
	};
};