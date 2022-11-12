/*
    File: fn_net_action_hold_fire.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Remote executed by clients to handle networked action events.
    
    Parameter(s):
		_event - Event that occurred [STRING]
		_args - Args for the event, depends on the event [ARRAY]
    
    Returns:
		None
    
    Example(s):
		See para_s_fnc_netaction rehandler.
*/

//_id is from the environment. Make sure it's set before calling this!
#define KEY(keyName) ([_id, keyName] call para_g_fnc_net_action_varname)

params ["_event", "_args"];

//Requires _id defined before it's called.
private _fnc_holdActionEvent = {
	private _nestedArgs = missionNamespace getVariable [KEY("arguments"), []];
	private _code = missionNamespace getVariable [KEY(_this), {}];
	_args set [3, _nestedArgs];
	_args call _code;
};

if (_event == "holdstart") exitWith {
	private _id = _args select 3 select 0;
	"codeStart" call _fnc_holdActionEvent;
};

if (_event == "holdcompleted") exitWith {
	private _id = _args select 3 select 0;
	"codeCompleted" call _fnc_holdActionEvent;
	private _removeCompleted = missionNamespace getVariable [KEY("removeCompleted"), true];
	if (_removeCompleted) then {
		[_id] call para_s_fnc_net_action_hold_remove
	};
};

if (_event == "holdinterrupted") exitWith {
	private _id = _args select 3 select 0;
	"codeInterrupted" call _fnc_holdActionEvent;
};