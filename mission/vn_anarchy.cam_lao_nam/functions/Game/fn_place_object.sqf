/*
  Author: Aaron Clark

  Description:
	Spawns object and loads related data

  Example Usage:
	["Land_vn_b_tower_01"] spawn vn_an_fnc_place_object;

  Parameter(s):
	NA

  Returns:
	NOTHING

*/

//code
params [["_class","Land_vn_b_tower_01"]];
private _buildables_config = missionConfigFile >> "gamemode" >> "buildables";
private _object_config = _buildables_config >> _class;
if (isClass _object_config) then
{
	private _initial_class = getText (_object_config >> "build_states" >> "initial_state" >> "object_class");
	private _pos = player getRelPos [5, 0];
	private _last_distance = 0;
	vn_an_placing_object = _initial_class createVehicle _pos;
	[player,'setlocaleh',[[vn_an_placing_object]],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];
	vn_an_offset = (vn_an_placing_object modelToWorld [0,0,0] select 2);
	vn_an_placing = true;
	vn_an_placing_started = false;
	vn_an_placing_allowed = true;
	private _player_rank = player getVariable ["vn_an_rank",0];
	private _buildables = "isClass _x" configClasses (_buildables_config) select {_player_rank >= getNumber(_x >> "rank")};

	private _action_id = [
		player,											// Object the action is attached to
		localize "STR_vn_an_build",										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Progress icon shown on screen
		"vn_an_placing && vn_an_placing_allowed",						// Condition for the action to be shown
		"vn_an_placing && vn_an_placing_allowed",						// Condition for the action to progress
		{
			vn_an_placing_started = true;
		},											// Code executed when action starts
		{},											// Code executed on every progress tick
		{
			params ["_target", "_caller", "_action_id", "_arguments"];
			vn_an_placing = false;
			_arguments params ['_buildables'];
			[player,"placedbuilding",[vn_an_placing_object,configName (_buildables select vn_an_buildindex)],player getVariable "vn_an_token"] remoteExecCall ["vn_an_fnc_rehandler",2];
			vn_an_placing_object = objNull;
			vn_an_buildMode = nil;
		},											// Code executed on completion
		{
			vn_an_placing_started = false;
		},												// Code executed on interrupted
		[_buildables],											// Arguments passed to the scripts as _this select 3
		2,												// Action duration [s]
		100,												// Priority
		true,												// Remove on completion
		false												// Show in unconscious state
	] call BIS_fnc_holdActionAdd;

	private _texture = "#(rgb,8,8,3)color(0,1,0,0.7)"; // green texture
	private _prevtexture = "";

	private _prev_build_index = vn_an_buildindex;

	while {vn_an_placing} do
	{
		//code
		if !(_prev_build_index isEqualTo vn_an_buildindex) then
		{
			_prev_build_index = vn_an_buildindex;
			detach vn_an_placing_object;
			deleteVehicle vn_an_placing_object;
			_class = getText ((_buildables select vn_an_buildindex) >> "build_states" >> "initial_state" >> "object_class");
			private _pos = player getRelPos [5, 0];
			vn_an_placing_object = _class createVehicle _pos;
			[player,'setlocaleh',[[vn_an_placing_object]],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];
			vn_an_offset = (vn_an_placing_object modelToWorld [0,0,0] select 2);
			vn_an_placing_object setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0,1,0,0.7)"];

		};
		private _pos = screenToWorld [0.5,0.5];
		_pos set [2,vn_an_offset];
		private _distance = player distance _pos;
		if (_distance > 3 && _distance < 10) then
		{
			if !(vn_an_placing_started) then
			{

				_texture = "#(rgb,8,8,3)color(0,1,0,0.7)"; // green texture

				// do restricted zone checks to make sure player did not move it into restricted zone
				if (["blocked_area1", "blocked_area2", "blocked_area3"] findIf {_pos inArea _x} isEqualTo -1) then
				{
					// this maybe clostly
					if ([vn_an_placing_object, getpos vn_an_placing_object] call vn_an_fnc_vehicle_will_collide_at_pos) then
					{
						_texture = "#(rgb,8,8,3)color(1,0,0,0.7)"; // red texture
						vn_an_placing_allowed = false;
					}
					else
					{
						vn_an_placing_allowed = true;
					// only reattach if offset changed.
					if !(_distance isEqualTo _last_distance) then
					{
						_last_distance = _distance;
						_endpos = player worldToModel _pos;
						vn_an_placing_object attachto [player,_endpos];
			};

				}
				else
				{
					_texture = "#(rgb,8,8,3)color(1,0,0,0.7)";  // blue texture
					vn_an_placing_allowed = false;
				};
			}
			else
			{
				_texture = "#(rgb,8,8,3)color(0,0,1,0.7)"; // blue texture
				// stop movement detach object
				detach vn_an_placing_object;
			};
		} else {
			_texture = "#(rgb,8,8,3)color(1,0,0,0.7)"; // red texture
			vn_an_placing_allowed = false;
		};



		// only set texture when changed
		if !(_texture isEqualTo _prevtexture) then
		{
			_prevtexture = _texture;
			vn_an_placing_object setObjectTextureGlobal [0, _texture];
		};
	};

	if !(isNull vn_an_placing_object) then
	{
		deleteVehicle vn_an_placing_object;
		[player,_action_id] call BIS_fnc_holdActionRemove;
	};

} else {
	["Building not in buildables config %1", _class] call BIS_fnc_logFormat;
};
