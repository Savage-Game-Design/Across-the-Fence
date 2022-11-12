/*
	File: fn_bf_respawn_on_functional.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
	  Called when a respawn building starts functioning.
	  Enables it as a respawn point.
	
	Parameter(s):
		_building - Building that became functional [OBJECT]
	
	Returns:
		Function reached the end [BOOL]
	
	Example(s):
		[parameter] call vn_fnc_myFunction
*/
params ["_building"];

private _objects = _building getVariable "para_g_objects";
private _classes = vn_drm_objects apply {_x # 0};
private _radioEntities = _objects apply { [_x, _classes find typeof _x] } select { _x # 1 >= 0 };

{
	_x params ["_entity", "_index"];

	// Enable radio
	_entity setVariable ["vn_drm_toggle", true, true];
	private _channel = _entity getVariable ["vn_drm_channel", -1];
	if (_channel <= -1) then
	{
		private _channels = vn_drm_objects#_index#1;
		_channel = _channels#0;
		_entity setVariable ["vn_drm_channel", _channel, true];
	};

	// Request sound from channel
	[_entity, _channel] remoteExec ["vn_fnc_drm_request_audio",0,true];

	[_entity] remoteExec ["vn_fnc_drm_localuseractions", 0, format ["vn_drm_localuseractions_%1", _object]];

	// Add radio to master array of mission objects
	vn_drm_objects_array pushBack _entity;
	// Send new array over network
	publicVariable "vn_drm_objects_array";
} forEach _radioEntities;