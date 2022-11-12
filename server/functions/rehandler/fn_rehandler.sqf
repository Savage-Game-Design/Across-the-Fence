/*
    File: fn_rehandler.sqf
    Author:  Savage Game Design
    Public: No

    Description:
		Remote execution handler.

    Parameter(s):
		_player - Player object making the call [Object, defaults to objNull]
		_method - Method for calling [String, defaults to "" (empty string)]
		_payload - Data passed to function [Array, defaults to [] (empty array)]

    Returns: nothing

    Example(s):
		_token = player getVariable ["para_token",""];
		_payload = [_task,_player];
		[player,"supporttaskcreate",_payload,_token] remoteExec ["para_s_fnc_rehandler",2];
*/

params [
	["_player",objNull,[objNull]],			// 0 : OBJECT - player object making the call
	["_method","",[""]],				// 1: STRING - method for calling
	["_payload",[]]				// 2: ARRAY - data passed to function
];

// check that player object making the call is the same as remoteExecutedOwner
private _owner = owner _player;
private _reowner = remoteExecutedOwner;
if (_owner isEqualTo 0 || _reowner isEqualTo 0) exitWith {};
if !(_owner isEqualTo _reowner) exitWith {};

// check if function is allowed to be called
private _config = missionConfigFile >> "CfgREHandler" >> _method;
if !(isClass _config) then {
	_config = configFile >> "CfgREHandler" >> _method;
};
if !(isClass _config) then {
	_config = missionConfigFile >> "gamemode" >> "rehandler" >> _method;
};
if !(isClass _config) exitWith {diag_log format ["ERROR: Paradigm, bad rehandler method: %1", _method]};

private _fnc_name = getText(_config >> "fnc");
// get function by var name
private _fnc = missionNamespace getVariable [_fnc_name,""];
// make sure that we found code
if (_fnc isEqualType {}) then
{
	// execute code
	_payload call _fnc;
};