/*
	File: fn_serialize_object.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
	Serializes an object into an array, ready to be persisted.
	
	Parameter(s):
		_object - Object to serialize [OBJECT]
	
	Returns:
		Serialized Object [ARRAY]
	
	Example(s):
		[_building, [["petrolQuantity", 10]]] call vn_fnc_myFunction
*/

params ["_object"];

private _varData = [_object] call para_g_fnc_serialize_namespace;

[
	typeOf _object, 
	getPosWorld _object, 
	[vectorDir _object, vectorUp _object], 
	_varData
];