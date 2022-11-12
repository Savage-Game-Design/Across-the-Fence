/*
	File: fn_placedbuilding.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Placed building handler.

	Parameter(s):
		_object - Object [Object, defaults to objNull]
		_buildableType - Object's classname [String, defaults to "" (empty string)]

	Returns:	
		Building created [OBJECT]

	Example(s): none
*/

params [
	["_objects",[], [[]]],		// 0 : OBJECT
	["_buildableType","",[""]]
];

if (_objects isEqualTo []) exitWith {
	diag_log format ["Error: Paradigm: 'PlacedBuilding' call for %2 received empty array of objects (%1)", _objects, _buildableType];
};

_objects select 0 params [["_mainObject", nil, [objNull]], ["_mainObjectPosWorld", nil, [[]], 3], ["_mainObjectDir", nil, [0]]];

//Use the assumption (for now) that all objects that are part of a building are of the same type (bridges)
private _spawnInfo = _objects apply {
	_x params [["_object", nil, [objNull]], ["_posWorld", nil, [[]], 3], ["_dir", nil, [0]]];
	deleteVehicle _object;
	[_posWorld, _dir]
};

private _buildableConfig = (missionConfigFile >> "gamemode" >> "buildables" >> _buildableType);

//Adds 10 minute decay time to freshly placed object.
private _gracePeriod = 600;
private _initialSupplies = getNumber(_buildableConfig >> "supply_consumption") * _gracePeriod;
private _initialBuildProgress = 0;

private _building = [_buildableType, _spawnInfo, _initialBuildProgress, _initialSupplies] call para_s_fnc_building_create;

diag_log format ["Paradigm: Placed building %1 based on objects %2", _buildableType, _objects];

_building
