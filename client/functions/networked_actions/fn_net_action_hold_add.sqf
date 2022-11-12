/*
    File: fn_net_action_hold_add.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Adds a hold action on the client, with the specific id, that calls back to the server.
    
    Parameter(s):
        _id - Id of the hold action, must match with the Id recorded on the server. [STRING]
		_target - Object to add the hold action to [OBJECT]
		_title - Title of the hold action. Can be a normal string, a string to localize, or a localization array. [STRING] or [ARRAY]
		_iconIdle - Icon to show when idle. [STRING]
		_iconProgress - Icon to show when progressing [STRING]
		_condShow - Whether or not to show the action. Runs on the client. [STRING]
		_condProgress - Whether or not the action can be progressed. Runs on the client. [STRING]
		_duration - How long the hold action takes. [NUMBER]
		_priority - priority of the action in the list. [NUMBER]
		_removeCompleted - Whether the action should be removed when completed. Should match with the server. [BOOLEAN]
		_showUnconscious - Whether or not the action should be shown when unconscious. [BOOLEAN]
		_showWindow - Same as BIS_fnc_holdActionAdd [BOOLEAN]
    
    Returns:
		Nothing
    
    Example(s):
        See fn_net_action_hold_add
*/

params
[
	"_id",
	["_target",objNull,[objNull]],
	["_title","MISSING TITLE",["", []]],
	["_iconIdle","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
	["_iconProgress","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
	["_condShow","true",[""]],
	["_condProgress","true",[""]],
	["_duration",10,[123]],
	["_priority",1000,[123]],
	["_removeCompleted",true,[true]],
	["_showUnconscious",false,[true]],
	["_showWindow",true,[true]]
];

private _localId = [
	_target,
	_title call para_c_fnc_localize_and_format,
	_iconIdle,
	_iconProgress,
	_condShow,
	_condProgress,
	{["net_action_hold_fire",["holdstart", _this]] call para_c_fnc_call_on_server},
	{},
	{["net_action_hold_fire",["holdcompleted", _this]] call para_c_fnc_call_on_server},
	{["net_action_hold_fire",["holdinterrupted", _this]] call para_c_fnc_call_on_server},
	[_id],
	_duration,
	_priority,
	_removeCompleted,
	_showUnconscious,
	_showWindow
] call BIS_fnc_holdActionAdd;

missionNamespace setVariable [[_id, "holdActionId"] call para_g_fnc_net_action_varname, [_target, _localId]];