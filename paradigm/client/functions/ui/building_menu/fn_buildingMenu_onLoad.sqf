/*
	File: fn_buildingMenu_onLoad.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Handles BM initial load.

	Parameter(s):
		_list - List of buildings you want to show [ARRAY, defaults to [] (empty array)]

	Returns: nothing

	Example(s): none
*/

params [
	["_list", [], [[]]]
];

private _display = uiNamespace getVariable ['#para_c_BuildingMenu_display', displayNull];
// TODO: Add keyboard support? Who use their kb to navigate UIs anyway?
// _display displayAddEventHandler ["KeyDown", {
// 	params ["_display", "_key"];
// 	systemChat str [_key];
// 	switch (_key) do {
// 		case 0;
// 		case 1: { // Enter/Space - Build

// 		};
// 		case 2: { // Tab - Change building

// 		};
// 	};
// }];

private _buildables = if (_list isEqualTo []) then { call para_c_fnc_buildingMenu_indexBuildings } else { _list };
localNamespace setVariable ["#para_c_buildingmenu_buildables", _buildables];

private _state = localNamespace getVariable ["#para_c_buildingMenu_state", [[],"",false,0,0,0]];
_state params [
	"_builds",
	"_query",
	"_avail",
	"_cat",
	"_page",
	"_building"
];

if (_builds isEqualTo _buildables) then {
	// Make the good stuff happen
	// Todo: figure out what was said good stuff

	private _searchControl = uiNamespace getVariable ["#para_c_BuildingMenu_Search", controlNull];
	private _availableControl = uiNamespace getVariable ["#para_c_BuildingMenu_Available", controlNull];
	private _categoryControl = uiNamespace getVariable ["#para_c_BuildingMenu_Select", controlNull];

	_searchControl ctrlSetText _query;
	_availableControl cbSetChecked _avail;
};

_state call para_c_fnc_buildingMenu_onUpdate;