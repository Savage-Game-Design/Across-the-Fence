/*
	File: fn_buildingMenu_onPageChange.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Handles the next/previous page action.
	
	Parameter(s):
		_isUser - Was the function triggered by the user or by script [BOOLEAN, defaults to FALSE]
		_n - By how much you want to move [NUMBER, defaults to 0]
		_isDelta - If true, then adds "_n" to the current page, otherwise, sets "_n" as the current page [BOOLEAN, defaults to true]

	Returns: nothing

	Example(s): none
*/

params [
	["_isUser", false, [false]],
	["_n", 0, [0]],
	["_isDelta", true, [true]]
];

private _buildings = localNamespace getVariable ["#para_c_buildingmenu_currList", []];
private _page = localNamespace getVariable ["#para_c_buildingmenu_page", 0];
private _max = ceil ((count _buildings) / 6) - 1;
if (_isDelta) then {
	_page = _page + _n max 0 min _max;
} else {
	_page = _n;
};
localNamespace setVariable ["#para_c_buildingmenu_page", _page];

call para_c_fnc_buildingMenu_onUpdate;