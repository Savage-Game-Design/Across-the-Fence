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
	vn_an_placing_object = _initial_class createVehicle [0,0,0];
	vn_an_placing = true;
	vn_an_placing_started = false;
	private _player_rank = player getVariable ["vn_an_rank",0];
	private _buildables = "isClass _x" configClasses (_buildables_config) select {_player_rank >= getNumber(_x >> "rank")};

	private _action_id = [
		player,											// Object the action is attached to
		localize "STR_vn_an_build",										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Progress icon shown on screen
		"vn_an_placing",										// Condition for the action to be shown
		"vn_an_placing",										// Condition for the action to progress
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

	private _prev_build_index = vn_an_buildindex;
	while {vn_an_placing} do
	{
		//code
		if !(_prev_build_index isEqualTo vn_an_buildindex) then
		{
			_prev_build_index = vn_an_buildindex;
			deleteVehicle vn_an_placing_object;
			_class = getText ((_buildables select vn_an_buildindex) >> "build_states" >> "initial_state" >> "object_class");
			vn_an_placing_object = _class createVehicle [0,0,0];
		};
		private _pos = screenToWorld [0.5,0.5];
		private _distance = player distance _pos;
		if (_distance > 3 && _distance < 10) then
		{
			if !(vn_an_placing_started) then
			{
				vn_an_placing_object setDir vn_an_buildDirection;
				vn_an_placing_object setPosASL AGLToASL _pos;
			};
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
