/*
  Author: Aaron Clark

  Description:
	Remote execution handler

  Example Usage:
	_token = player getVariable ["vn_mf_token",""];
	_payload = [_task,_player];
	[player,"supporttaskcreate",_payload,_token] remoteExec ["vn_mf_fnc_rehandler",2];

  Returns:
	OBJECT

  Parameter(s):
*/
params [
	["_player",objNull,[objNull]],			// 0 : OBJECT - player object making the call
	["_method","",[""]],				// 1: STRING - method for calling
	["_payload",[],[[]]],				// 2: ARRAY - data passed to function
	["_token","FAIL"]				// 3: STRING - token used to validate
];

// check that player object making the call is the same as remoteExecutedOwner
private _owner = owner _player;
private _reowner = remoteExecutedOwner;
if (_owner isEqualTo 0 || _reowner isEqualTo 0) exitWith {};
if !(_owner isEqualTo _reowner) exitWith {};

// sanity token check
private _serverToken = _player getVariable ["vn_mf_token","FAIL"];
if (_token isEqualTo "FAIL" || _serverToken isEqualTo "FAIL") exitWith {};
if !(_token isEqualTo _serverToken) exitWith {};

// check if function is allowed to be called
private _gamemode_config = (missionConfigFile >> "gamemode");
private _allowed_functions = getArray(_gamemode_config >> "rehandler" >> "allowedfunctions");
if (_method in _allowed_functions) then
{
	// get function by var name
	private _fnc = missionNamespace getVariable [format["vn_mf_fnc_%1", _method],""];
	// make sure that we found code
	if (_fnc isEqualType {}) then
	{
		// execute code
		_payload call _fnc;
	};
};
