/*
	File: fn_building_on_deconstructed.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Called when a building goes from being constructed to being partially built.
	
	Parameter(s):
		_building - Building that's being deconstructed [OBJECT]
		_updateObjects - Whether or not to update the objects that make up the building [BOOLEAN] (default true)
	
	Returns:
		None
	
	Example(s):
		[_building, true] call para_s_fnc_building_on_deconstructed;
*/

params ["_building", ["_updateObjects", true]];

//Set the building state, and do a functional update - which should mark it as "non-functional"
_building setVariable ["para_g_building_constructed", false, true];
[_building] call para_s_fnc_building_functional_update;

private _buildableConfig = [_building] call para_g_fnc_get_building_config;

private _objects = _building getVariable ["para_g_objects", []];
if (_updateObjects) then
{
	private _newClass = getText (_buildableConfig >> "build_states" >> "middle_state" >> "object_class");
	private _newObjects = _objects apply {[_newClass, _x] call para_s_fnc_replace_building};
	[_building, _newObjects] call para_s_fnc_building_change_objects;
};

//This should be replaced. We use this for tracking buildings of different types.
private _typeVariable = format["para_buildings_%1",getText (_buildableConfig >> "type")];
//We save the objects into here. Ideally would save the buildings, but most code atm relies on them being objects.
private _typeList = missionNamespace getVariable _typeVariable;
private _objectIndexInTypeList = _typeList find (_objects # 0);
if (_objectIndexInTypeList > -1) then {
	_typeList deleteAt _objectIndexInTypeList;
};

[_building] call para_s_fnc_building_disconnect_base;
//TODO - Delete base if core building is removed.