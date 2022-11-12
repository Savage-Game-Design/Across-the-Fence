/*
	File: fn_buildingMenu_quickBuild.sqf
	Author:  Savage Game Design
	Public: No

	Description: TODO

	Parameter(s): TODO

	Returns: TODO

	Example(s): TODO
*/

private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
if (_classname isEqualTo "") exitWith {};

private _config = missionConfigFile >> "gamemode" >> "buildables" >> _classname;
private _conditionList = getArray (_config >> "conditions");
private _conditions = _conditionList apply { call compile (_x#1) };

if (false in _conditions) exitWith {};
[_classname, [[_config], para_c_fnc_building_check]] spawn para_c_fnc_place_object;
