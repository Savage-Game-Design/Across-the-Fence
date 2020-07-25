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

private _fnc_add_action =
{
	params
	[
		"_agent", 				// 0: OBJECT - existing object
		"_str_drop", 				// 1: STRING - localized string
		["_request","BuildingSupplies"]		// 2: STRING - requested supplies
	];
	_actions = _agent getVariable ["vn_dyn_mf_actions",[]];
	_actions pushBack ["vn\ui_f_vietnam\ui\wheelmenu\img\handsignals\ui_wm_selector_hand_002_ca.paa", "",    [ [[_request,_agent], format[localize "STR_vn_an_requestdrop",localize _str_drop]],"vn_an_fnc_client_request_supplies"] ];
	_agent setVariable ["vn_dyn_mf_actions", _actions];
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
    	[_agent,_request_name,_request] call _fnc_add_action;
    };

} forEach _supplydrops;
