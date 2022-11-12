/*
    File: fn_hold_action_add_serverside.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        No description added yet.
    
    Parameter(s):
		_target - Object to add the hold action to [OBJECT]
		_title - Title of the hold action. Can be a normal string, a string to localize, or a localization array. [STRING] or [ARRAY]
		_iconIdle - Icon to show when idle. [STRING]
		_iconProgress - Icon to show when progressing [STRING]
		_condShow - Whether or not to show the action. Runs on the client. [STRING]
		_condProgress - Whether or not the action can be progressed. Runs on the client. [STRING]
		_codeStart - Code called on the server when the action is started by a player [CODE]
		_codeCompleted - Code called on the server when the action is finished by a player [CODE]
		_codeInterrupted - Code called on the server when the action is interrupted part-way through by a player [CODE]
		_duration - How long the hold action takes. [NUMBER]
		_priority - priority of the action in the list. [NUMBER]
		_removeCompleted - Whether the action should be removed when completed. Should match with the server. [BOOLEAN]
		_showUnconscious - Whether or not the action should be shown when unconscious. [BOOLEAN]
		_showWindow - Same as BIS_fnc_holdActionAdd [BOOLEAN]
    
    Returns:
        Id of the hold action [STRING]
    
    Example(s):
		See BIS_fnc_holdActionAdd
*/

params
[
	["_target",objNull,[objNull]],
	["_title","MISSING TITLE",["", []]],
	["_iconIdle","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
	["_iconProgress","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
	["_condShow","true",[""]],
	["_condProgress","true",[""]],
	["_codeStart",{},[{}]],
	["_codeCompleted",{},[{}]],
	["_codeInterrupted",{},[{}]],
	["_arguments",[],[[]]],
	["_duration",10,[123]],
	["_priority",1000,[123]],
	["_removeCompleted",true,[true]],
	["_showUnconscious",false,[true]],
	["_showWindow",true,[true]]
];

private _holdActionCount = missionNamespace getVariable ["para_s_holdActionCount", 0];
missionNamespace setVariable ["para_s_holdActionCount", _holdActionCount + 1];

//First part guarantees uniqueness - second part makes them less predictable, in case there was an attacker.
private _id = (str _holdActionCount) + (str random 1000000);

#define KEY(keyName) ([_id, keyName] call para_g_fnc_net_action_varname)

missionNamespace setVariable [KEY("codeStart"), _codeStart];
missionNamespace setVariable [KEY("codeCompleted"), _codeCompleted];
missionNamespace setVariable [KEY("codeInterrupted"), _codeInterrupted];
missionNamespace setVariable [KEY("arguments"), _arguments];
missionNamespace setVariable [KEY("removeCompleted"), _removeCompleted];

[
	_id,
	_target,
	_title,
	_iconIdle,
	_iconProgress,
	_condShow,
	_condProgress,
	_duration,
	_priority,
	_removeCompleted,
	_showUnconscious,
	_showWindow
] remoteExec ["para_c_fnc_net_action_hold_add", 0, KEY("JIP")];

_id