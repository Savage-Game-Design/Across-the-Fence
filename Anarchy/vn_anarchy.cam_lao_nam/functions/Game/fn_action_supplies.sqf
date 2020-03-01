/*
  Author: Aaron Clark

  Description:
	Adds action to request supplies

  Example Usage:
	call vn_an_fnc_action_supplies;

  Returns:
	NOTHING

  Parameter(s):
*/

private _fnc_add_holdAction =
{
	params
	[
		"_agent", 				// 0: OBJECT - existing object
		"_str_drop", 				// 1: STRING - localized string
		["_request","BuildingSupplies"]		// 2: STRING - requested supplies
	];
	[
		_agent,									// Object the action is attached to
		format[localize "STR_vn_an_requestdrop",localize _str_drop],		// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Progress icon shown on screen
		"_this distance _target < 6", 						// Condition for the action to be shown
		"_caller distance _target < 6",						// Condition for the action to progress
		{},									// Code executed when action starts
		{},									// Code executed on every progress tick
		{
			params ['_target', '_caller', '_action_id', '_arguments'];
			_arguments params ['_request','_agent'];
			[player,'supplyrequest',[_request,_agent],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];
		},									// Code executed on completion
		{},									// Code executed on interrupted
		[_request,_agent],							// Arguments passed to the scripts as _this select 3
		2,									// Action duration [s]
		100,									// Priority
		false,									// Remove on completion
		false									// Show in unconscious state
	] call BIS_fnc_holdActionAdd;
};

private _gamemode_config = (missionConfigFile >> "gamemode");

private _supplydrops = configProperties [_gamemode_config >> "supplydrops"];
// add supply officer actions
{
    private _request = configName _x;
    getArray(_gamemode_config >> "supplydrops" >> _request) params ["_request_name"];
    for "_i" from 1 to 10 do
    {
    	private _agent = missionNamespace getVariable [format["supply_officer_%1",_i],objNull];
    	if (isNull _agent) exitWith {};
    	[_agent,_request_name,_request] call _fnc_add_holdAction;
    };

} forEach _supplydrops;
