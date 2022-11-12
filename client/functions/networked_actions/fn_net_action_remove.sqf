/*
	File: fn_net_action_hold_remove.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Removes a hold action with the given Id from the client
	
	Parameter(s):
		_id - Id of the old action

	Returns:
		None
	
	Example(s):
		See fn_net_action_hold_remove
*/

params ["_id"];

private _key = [_id, "actionId"] call para_g_fnc_net_action_varname;

private _actionInfo = localNamespace getVariable [_key, []];

if !(_actionInfo isEqualTo []) then {
	_actionInfo params ["_target", "_localId"];
	_target removeAction _localId;
	localNamespace setVariable [_key, nil];
};
