/*
	File: fn_building_on_constructed.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Called when a building has been constructed

	Parameter(s):
		_building - Building that has been constructed [OBJECT]
		_updateObjects - Whether or not to update the objects that make up the building [BOOLEAN] (default true)

	Returns:
		None

	Example(s):
		[_building, true] call para_s_fnc_building_on_constructed;
*/

params ["_building", ["_updateObjects", true]];

private _buildableConfig = [_building] call para_g_fnc_get_building_config;

private _objects = _building getVariable ["para_g_objects", []];
if (_updateObjects) then
{
	private _newClass = getText (_buildableConfig >> "build_states" >> "final_state" >> "object_class");
	_objects = _objects apply {[_newClass, _x] call para_s_fnc_replace_building};
	[_building, _objects] call para_s_fnc_building_change_objects;
};

//This should be replaced. We use this for tracking buildings of different types.
private _typeVariable = format["para_buildings_%1",getText (_buildableConfig >> "type")];
//We save the objects into here. Ideally would save the buildings, but most code atm relies on them being objects.
private _allObjectsOfType = missionNamespace getVariable _typeVariable;
//This should do nothing if the object is already the right type.
_allObjectsOfType pushBack _objects # 0;
missionNamespace setVariable [_typeVariable, _allObjectsOfType];

//If the building can create a base, and there's no bases nearby
private _basesContaining = getPos _building call para_g_fnc_bases_containing_pos;
private _isBaseStarter = isClass (_buildableConfig >> "features" >> "base_starter");
if (_isBaseStarter && _basesContaining isEqualTo []) then {
	private _base = [getPos _building] call para_s_fnc_base_create;
	_basesContaining pushBack _base;
};

if !(_basesContaining isEqualTo []) then {
	[_building, _basesContaining # 0] call para_s_fnc_building_connect_base;
};

_building setVariable ["para_g_building_constructed", true, true];
[_building] call para_s_fnc_building_functional_update;
