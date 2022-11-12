/*
	File: fn_getKeyName.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		keyName command returns ""Keyname"". This functions returns "Keyname".
	
	Parameter(s):
		_dik - DIK code of the key [NUMBER, defaults to NIL]
	
	Returns:
		Keyname [STRING]
	
	Example(s):
		[0] call para_c_fnc_getKeyName; // "Escape"
*/

params ["_dik"];
_kn = keyName _dik;
_kn select [1, count _kn -2]