/*
	File: fn_buildingMenu_onSelect.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Handles when a user clicks on a building.
	
	Parameter(s):
		_isUser - Was the function triggered by the user or by script [BOOLEAN, defaults to FALSE]
		_index - Index of selected building [NUMBER, defaults to 0]

	Returns: nothing

	Example(s): none
*/

params [
	["_isUser", false, [false]],
	["_index", 0, [0]]
];

private _tableControl = uiNamespace getVariable ["#para_c_BuildingMenu_Table", controlNull];
private _class = _tableControl ctData _index;
localNamespace setVariable ["#para_c_BuildingMenu_class", _class];

call para_c_fnc_buildingMenu_onUpdate;