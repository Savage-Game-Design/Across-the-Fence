/*
	File: fn_get_key_bind.sqf
	Author:  Savage Game Design
	Public: No

	Description:
	No description added yet.

	Parameter(s):
	_action - name of keybind action [STRING, defaults to "", requires STRING]

	Returns:
	Array containing currently bound key and shift,ctrl,alt state. Returns empty array if not found [ARRAY]

	Example(s):
	["para_keydown_enable_selector"] call para_c_fnc_get_key_bind;
*/
params
[
	["_action","",[""]]
];
private _key_bind = [];
private _config = (missionConfigFile >> "gamemode" >> "keys" >> _action);
if (isClass _config) then
{
	_defaultValue = [getNumber(_config >> "defaultKey"),getText(_config >> "shift"),getText(_config >> "ctrl"),getText(_config >> "alt")];
	_key_bind = profileNamespace getVariable [_action, _defaultValue];
	if !(_key_bind isEqualType []) then {_key_bind = _defaultValue};
};
_key_bind
