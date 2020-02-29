/*
  Author: Aaron Clark

  Description:
	creates and initialize groups and duty officers

  Example Usage:
	call vn_mf_fnc_group_init;

  Returns:
	NOTHING

*/
vn_mf_duty_officers = [];

// Create all groups agents and join into all groups
private _groups = getArray(_gamemode_config >> "settings" >> "groups" );
{
	_x params ["_group_name", ["_class","uns_men_RAR_65_COM"]];
	private _marker = "respawn_west_" + toLower(_group_name);
	private _location = getMarkerPos _marker;
	if !(_location isEqualTo [0,0,0]) then
	{

		_marker setMarkerAlpha 0;
		// create duty officer
		private _grp = createGroup [west, false];
		_grp setGroupIdGlobal [_group_name];

		// make visible marker
		private _marker_duty = createMarker [format["%1_dot",toLower(_group_name)], _location];
		_marker_duty setMarkerShape "ICON";
		_marker_duty setMarkerType "mil_dot";
		getArray(_gamemode_config >> "settings" >> "teams" >> _group_name) params ["_marker_name"];
		_marker_duty setMarkerText format["Duty Officer (%1)",_marker_name];
		_marker_duty setMarkerColor "ColorWhite";

		// duty officer agent
		private _agent = createAgent [_class, _location, [], 0, "NONE"];
		_agent enableSimulationGlobal false;
		_agent disableAI "ALL";
		_agent allowDamage false;
		removeAllWeapons _agent;

		// set group name as global var and reference to group server side
		missionNamespace setVariable [_group_name,_grp];

		// save duty officers to array for later use
		vn_mf_duty_officers pushBack _agent;
	};
} forEach _groups;

// broadcast duty officers
publicVariable "vn_mf_duty_officers";
