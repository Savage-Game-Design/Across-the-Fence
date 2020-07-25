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
	_actions = _agent getVariable ["vn_dyn_mf_actions",[]];
	_actions pushBack ["vn\ui_f_vietnam\ui\wheelmenu\img\handsignals\ui_wm_selector_hand_002_ca.paa", "",    [ [[_location,_agent], format[localize "STR_vn_an_goto",_str_loc call BIS_fnc_localize]],"vn_an_fnc_client_teleport"] ];
	_agent setVariable ["vn_dyn_mf_actions", _actions];
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
