// setup key handler functions
private _key_actions = getArray(missionConfigFile >> "gamemode" >> "keys" >> "key_down_actions");
{
	_x params ["_key_action","_default_key","_function"];
	missionNamespace setVariable [format["vn_an_fnc_key_%1",(profileNamespace getVariable [_key_action,_default_key])],_function];
} forEach _key_actions;
