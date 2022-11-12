/*
    File: fn_wheel_menu_open.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
		Enables Dynamic Wheel Menu Selector.

    Parameter(s):
		_actions - Array of actions. See Actions array entries <ARRAY>
		_object - Object to open the wheel menu on. Used for distance checks. <OBJECT>
		_forceOpen - Open, overwriting any existing wheel menu <BOOLEAN>

	Actions hashmap:
		condition - Whether or not the action should be displayed. <BOOL> or <CODE>
		iconPath - Path to the icon to show in the wheel menu <STRING>
		iconPathHighlighted - Path to the icon to show when item is highlighted <STRING>,
		functionArguments - Arguments to pass to the function being called. These will be available as the first item in the function's "_this" array. <ANY>
		text - Text to show in the menu. Can be a <STRING>, or an <ARRAY> in the format [Arguments, Code].
			   This will be called on the client for localization. Must return a <STRING>
		function - Name of the function to call <STRING>
		spawnFunction - Whether the function should be spawned or called <BOOL>
		selectorColorcodes - Colour of the selector. <ARRAY>, formatted: [<Colour Array>, <Colour Array>]. Optional.
		iconColorcodes - Colour of the icon. <ARRAY>, formatted: [<Colour Array>, <Colour Array>]. Optional

    Returns:
		True if we can open the wheel menu [BOOL]

    Example(s):
		call para_c_fnc_wheel_menu_open;
*/

params ["_actions", ["_object", objNull], ["_forceOpen", false]];

private _display = uiNamespace getVariable ["vn_wheelmenu", displayNull];

// Avoid reopening the wheel menu unless we're force opening.
if (!isNull _display && !_forceOpen) exitWith { false };

// Convert any actions with submenus into submenu actions
private _expandedActions = [];

{
	private _action = _x;
	private _submenuActions = _action getOrDefault ["submenuActions", []];
	if (count _submenuActions > 0) then {
		// Copy to avoid unexpected changes to the hashmap elsewhere
		_action = +_x;
		_action set ["function", "para_c_fnc_wheel_menu_submenu_open"];
		// Copy _submenuActions to try and avoid a circular reference.
		_action set ["functionArguments", [_actions, +_submenuActions, _object]];
	};

	_expandedActions pushBack _action;
} forEach _actions;
// Filter out any invalid conditions
private _validActions = _expandedActions select {
	private _condition = _x getOrDefault ["condition", true];

	if (_condition isEqualType {}) then {
		_condition = _object call _condition;
	};

	_condition
};

private _wheelMenuEntries = _validActions apply {
	[_object, _x] call para_c_fnc_wheel_menu_create_entry
};

//Wheel menu won't open with 1 entry.
//Need to add a blank placeholder.
if (count _wheelMenuEntries == 1) then
{
	_wheelMenuEntries pushBack [
		"",
		"",
		[[[], ""], "", true],
		[ [0.2,0.2,0.2,0.8], [0.8,0.8,0.8,1] ],
		[ [0.6,0.6,0.6,0.8], [1,1,1,0.95] ]
	]
};



// close old menu
private _oldDisplay = uiNamespace getVariable ["vn_wheelmenu", displayNull];
if (!isNull _oldDisplay) then {
	_oldDisplay closeDisplay 1;
};

[_wheelMenuEntries, _object] spawn {
	params ["_wheelMenuEntries", "_object"];
	// Try to stop wheel menus clashing with each other if close/open overlaps for some reason
	uiSleep 0;

	// close menu on repeated press
	private _EH_closeWM = {
		params["_display","_button","_shift","_ctrl","_alt"];

		if (isNull (uiNamespace getVariable ["vn_wheelmenu", displayNull])) exitWith {};

		private _key_bind = ["para_keydown_open_wheel_menu"] call para_c_fnc_get_key_bind;
		if(([_button,_shift,_ctrl,_alt] joinString "_") isEqualTo (_key_bind joinString "_"))then
		{
			if(!isNull _display)then
			{
				_display closeDisplay 1;
			};
		};
	};

	private _EH_Unload = {
		params ["_display", "_exitCode"];
		uiNamespace setVariable ["vn_wheelmenu", nil];
	};

	private _PFEH_distanceCheck = {
		private _object = para_c_wheel_menu_current_object;

		// Check is dialog is open.
		if !(isNull (uiNamespace getVariable ["vn_wheelmenu", displayNull])) then
		{
			// Don't run any checks if we're not targeting anything or are targeting ourselves.
			if (isNull _object || _object == player) exitWith {};

			getCursorObjectParams params ["_targetNew", "", "_distance"];
			// Check if player is outside 5m if so close Dialog and reset variables.
			if (_distance > 5 || _object != _targetNew) then {
				_display = uiNamespace getVariable ["vn_wheelmenu", displayNull];
				_display closeDisplay 1;
			};
		} else {
			para_c_wheel_menu_frame_handler = nil;
			removeMissionEventhandler ["EachFrame", _thisEventhandler];
		};
	};

	[_wheelMenuEntries] call vn_fnc_wm_init;
	private _display = uiNamespace getVariable ["vn_wheelmenu", displayNull];
	// Abort if we failed to open the wheel menu
	if (isNull _display) exitWith { false };

	// add handler to close menu
	_display displayAddEventHandler ["KeyDown", _EH_closeWM];
	_display displayAddEventHandler ["Unload", _EH_Unload];

	// add mission eachFrame EH to check distance
	para_c_wheel_menu_current_object = _object;
	if (isNil "para_c_wheel_menu_frame_handler") then {
		para_c_wheel_menu_frame_handler = addMissionEventhandler ["EachFrame", _PFEH_distanceCheck, [_object]];
	};
};