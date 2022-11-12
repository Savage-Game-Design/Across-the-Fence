/*
    File: fn_wheel_menu_open.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
		Wheel menu action generator that opens a submenu.

    Parameter(s): 
		_currentMenuActions - All actions currently shown on this menu
		_submenuActions - Actions to show on the submenu
		_object - Object the wheel menu was previously open on

    Returns:
		Nothing

    Example(s):
		call para_c_fnc_wheel_menu_open;
*/
params [["_currentMenuActions", []], ["_submenuActions", []], ["_object", objNull]];

private _back = createHashmapFromArray [
	["iconPath", "img\vn_ico_mf_back.paa"],
	["functionArguments", [_currentMenuActions, _object, true]],
	["function", "para_c_fnc_wheel_menu_open"],
	["spawnFunction", true],
	["text", "Back"]
];

[[_back] + _submenuActions, _object, true] spawn para_c_fnc_wheel_menu_open