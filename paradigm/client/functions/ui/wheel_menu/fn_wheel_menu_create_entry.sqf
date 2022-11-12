/*
    File: fn_wheel_menu_create_wheel_menu_entry.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Creates a new wheel menu entry to be used with wheel_menu_open
    
    Parameter(s):
		_object - Object to add wheel menu item to <OBJECT>
		_action - Action to add, see actions hashmap for reference <HASHMAP>

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
		Entry for wheel_menu_open [ARRAY]
    
    Example(s):
		None
*/

params [
	"_object",
	"_action"
];

private _text = _action getOrDefault ["text", ""];
//Allow text to be a function, so we can perform localisation on the client.
if (_text isEqualType [] && {count _text > 1 && {_text select 1 isEqualType {}}}) then {
	_text = (_text select 0) call (_text select 1);
};

//We wrap the callback, to make it nicer to use.
private _args = [
	_object, 
	_action getOrDefault ["functionArguments" , []], 
	_action getOrDefault ["function", ""],
	_action getOrDefault ["condition", true]
];

[
	_action getOrDefault ["iconPath", ""],
	_action getOrDefault ["iconPathHighlighted", ""],
	[[_args, _text], "para_c_fnc_wheel_menu_callback_wrapper", _action getOrDefault ["spawnFunction", false]],
	_action getOrDefault ["selectorColorCodes", [ [0.2,0.2,0.2,0.8], [0.8,0.8,0.8,1] ]],
	_action getOrDefault ["iconColorCodes", [ [0.6,0.6,0.6,0.8], [1,1,1,0.95] ]]
]