/*
	File: fn_add_allow_damage_persistence.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		When an object shifts from one machine to another, persist its allowDamage status.
	
	Parameter(s):
		_object - Object to add allow_damage persistence to. [OBJECT]
	
	Returns:
		None
	
	Example(s):
		[cursorObject, false] call para_s_fnc_allow_damage_persistent
*/

params ["_object"];

if (_object getVariable ["para_l_allow_damage_persistence_applied", false]) exitWith {};

_object addEventHandler ["Local", {
	params ["_entity", "_isLocal"];

	if (!_isLocal) exitWith {};

	_entity allowDamage (_entity getVariable ["para_g_allow_damage", false]);
}];

_object setVariable ["para_l_allow_damage_persistence_applied", true];