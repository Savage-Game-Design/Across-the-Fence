/*
    File: fn_wheel_menu_open_with_default_actions.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Opens the wheel menu, loading actions from global variables and target object.

    Parameter(s): 
        _extraActions - Any extra actions to add, see actions hashmap <ARRAY>
        _forceOpen - Open the wheel menu, even if there's already a menu open <BOOLEAN>

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
        True if wheel menu was opened [BOOL]

    Example(s):
        call para_c_fnc_wheel_menu_open_with_configured_actions;
*/
params [["_extraActions", []], ["_forceOpen", false]];

private _isIncapacitated = [player] call para_g_fnc_unit_is_incapacitated;
if (_isIncapacitated) exitWith { false };

getCursorObjectParams params ["_target", "_selections", "_distance"];
private _actions = [];

// find target or use player if target is too far away
if (isNull _target || {_distance > 5}) then
{
	_target = player;
    ["enteredWheelMenu", [player, _target]] call para_g_fnc_event_dispatch;
	_actions append para_c_wheel_menu_actions_no_target;
} else {
    ["enteredWheelMenu", [player, _target]] call para_g_fnc_event_dispatch;
    _actions append (_target getVariable ["para_wheel_menu_dyn_actions", []]);
};

_actions append para_c_wheel_menu_actions_always;
_actions append _extraActions;

[_actions, _target, _forceOpen] call para_c_fnc_wheel_menu_open;