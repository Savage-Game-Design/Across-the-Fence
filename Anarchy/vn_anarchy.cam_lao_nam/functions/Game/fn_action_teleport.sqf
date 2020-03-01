/*
  Author: Aaron Clark

  Description:
	Adds action to teleport

  Example Usage:
	call vn_an_fnc_action_teleport

  Returns:
	NOTHING

  Parameter(s):
*/
private _fnc_add_action_teleport =
{
	params
	[
		"_agent", 				// 0: OBJECT - existing object
		"_str_loc", 				// 1: STRING - localized string
		["_location",[]]	// 2: STRING - requested supplies
	];
	[
		_agent,									// Object the action is attached to
		format[localize "STR_vn_an_goto",_str_loc call BIS_fnc_localize],		// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Progress icon shown on screen
		"_this distance _target < 6", 						// Condition for the action to be shown
		"_caller distance _target < 6",						// Condition for the action to progress
		{},									// Code executed when action starts
		{},									// Code executed on every progress tick
		{
			params ['_target', '_caller', '_action_id', '_arguments'];
			_arguments params ['_location','_agent'];
			[player,'teleport',[_location,_agent],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];
		},									// Code executed on completion
		{},									// Code executed on interrupted
		[_location,_agent],							// Arguments passed to the scripts as _this select 3
		2,									// Action duration [s]
		100,									// Priority
		false,									// Remove on completion
		false									// Show in unconscious state
	] call BIS_fnc_holdActionAdd;
};

// determine respawn locations for use with teleport actions
private _respawn_locations = [];
{
	if (_x find "respawn_west_" isEqualTo 0) then
	{
		_respawn_locations pushBack _x;
	};
} forEach allMapMarkers;

{
	private _agent = _x;
	{
		private _marker_pos = getMarkerPos _x;
            	if (_agent distance _marker_pos > 10) then
            	{
            		[_agent,markerText _x,_marker_pos] call _fnc_add_action_teleport;
            	};
	} forEach _respawn_locations;
} forEach vn_an_duty_officers;
