/*
    File: fn_interactionOverlay_init.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Sets the title, icon, and description of the Interaction HUD.

    Parameter(s):
		_object - Interactible object [Object, defaults to objNull]

    Returns:
		False if HUD has already been initialized [Boolean]

    Example(s): none
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params [
	["_object", objNull, [objNull]]
];

private _group = uiNamespace getVariable ['#para_InteractionOverlay_Main', controlNull];
private _title = uiNamespace getVariable ['#para_InteractionOverlay_TitleText', controlNull];
private _icon = uiNamespace getVariable ['#para_InteractionOverlay_TitleIcon', controlNull];
private _body = uiNamespace getVariable ['#para_InteractionOverlay_Body', controlNull];
private _text = uiNamespace getVariable ['#para_InteractionOverlay_BodyText', controlNull];
private _background = uiNamespace getVariable ['#para_InteractionOverlay_BodyBackground', controlNull];

private _type = typeOf _object;
private _config = configFile >> "CfgVehicles" >> _type;

private _baseName = getText (_config >> "displayName");
private _basePicture = getText (_config >> "icon");
private _baseDescription = "";
private _baseVariables = [];

private _customOverlayType = _object getVariable ["#para_InteractionOverlay_ConfigClass", ""];
private _overlayConfig = if (_customOverlayType isEqualTo "") then {
	missionConfigFile >> "gamemode" >> "interaction_overlay" >> _type
} else {
	missionConfigFile >> "gamemode" >> "interaction_overlay" >> _customOverlayType
};

private _configName = getText (_overlayConfig >> "name");
private _configPicture = getText (_overlayConfig >> "icon");
private _configDescription = getText (_overlayConfig >> "description");
private _configVariables = getArray (_overlayConfig >> "variables");

private _scriptData = _object getVariable ["#para_InteractionOverlay_Data", []];
_scriptData params [
	["_scriptName", "", [""]],
	["_scriptPicture", "", [""]],
	["_scriptDescription", "", [""]],
	["_scriptVariables", {[]}, [{}]],
	["_scriptInteractive", true, [true]]
];

private _name = call {
	if !(_scriptName isEqualTo "") exitWith { _scriptName };
	if !(_configName isEqualTo "") exitWith { _configName };
	_baseName;
};
private _picture = call {
	if !(_scriptPicture isEqualTo "") exitWith { _scriptPicture };
	if !(_configPicture isEqualTo "") exitWith { _configPicture };
	_basePicture;
};
private _description = call {
	if !(_scriptDescription isEqualTo "") exitWith { _scriptDescription };
	if !(_configDescription isEqualTo "") exitWith { _configDescription };
	_baseDescription;
};
private _variables = call {
	if !(_scriptVariables isEqualTo []) exitWith { _object call _scriptVariables };
	if !(_configVariables isEqualTo []) exitWith { _object call compile _configVariables };
	_baseVariables;
};

_description = format ([_description] + _variables);

// Checking if this is a valid image
private _picture = ["", _picture] select ((_picture select [(count _picture) - 4, 4]) isEqualTo ".paa"); // Yeah whatever

private _keybind = ["para_keydown_open_wheel_menu"] call para_c_fnc_get_key_bind;
_keybind params ["_key", "_shift", "_ctrl", "_alt"];
private _keyName = (keyName _key) select [1,1];

private _keyNameControl = uiNamespace getVariable ['#para_InteractionOverlay_InteractionKeyName', controlNull];
_keyNameControl ctrlSetText _keyName;

private _modifierOffset = (UIH(0.8) * (3 / 4) * 3 + UIH(0.1));

private _mainkeygroup = uiNamespace getVariable ['#para_InteractionOverlay_InteractionKey', controlNull];
private _modifierGroup = uiNamespace getVariable ['#para_InteractionOverlay_InteractionKeyModifierGroup', controlNull];
private _keyGroup = uiNamespace getVariable ['#para_InteractionOverlay_InteractionKeyKeyGroup', controlNull];
private _actionText = uiNamespace getVariable ['#para_InteractionOverlay_ActionText', controlNull];
private _actionGroup = uiNamespace getVariable ['#para_InteractionOverlay_Action', controlNull];

/* Modifier Handling */
// Yes it's messy and all but it works
if ("true" in _keybind) then {
	{
		_x params ["_control", "_pos"];
		_control ctrlSetPositionX _pos;
		_control ctrlCommit 0;
	} forEach [
		[_modifierGroup, UIH(0.1)],
		[_keyGroup, (UIH(0.1)) + _modifierOffset],
		[_actionText, (UIH(1) * (3 / 4) + UIH(0.1)) + _modifierOffset - UIH(0.1)]
	];

	_mainkeygroup ctrlSetPositionW ((UIH(0.8) * (3 / 4)) + _modifierOffset + UIH(0.1));
	_mainkeygroup ctrlCommit 0;

	private _modifierName = ["", "Shift", "Ctrl", "Alt"]#(_keybind find "true");
	private _modifierTextControl = uiNamespace getVariable ['#para_InteractionOverlay_InteractionModifierName', controlNull];
	_modifierTextControl ctrlSetText _modifierName;

	private _actionPos = uiNamespace getVariable ['#para_InteractionOverlay_ModifiedPosition', [0,0]];
	_actionGroup ctrlSetPositionX (_actionPos#0 - _modifierOffset);
	_actionGroup ctrlSetPositionW (_actionPos#1 + _modifierOffset);
	_actionGroup ctrlCommit 0;
} else {
	{
		_x params ["_control", "_pos"];
		_control ctrlSetPositionX _pos;
		_control ctrlCommit 0;
	} forEach [
		[_modifierGroup, UIH(0.1) - _modifierOffset],
		[_keyGroup, UIH(0.1)],
		[_actionText, UIH(1) * (3 / 4)]
	];

	_mainkeygroup ctrlSetPositionW (UIH(0.8) * (3 / 4) + UIH(0.1)) ;
	_mainkeygroup ctrlCommit 0;

	private _actionPos = uiNamespace getVariable ['#para_InteractionOverlay_ModifiedPosition', [0,0]];
	_actionGroup ctrlSetPositionX (_actionPos#0);
	_actionGroup ctrlSetPositionW (_actionPos#1);
	_actionGroup ctrlCommit 0;
};

_title ctrlSetText _name;
_icon ctrlSetText _picture;

/* GUI GRIDS VAR */
private _w = UIW(1);
private _h = UIH(1);

/* Progress Bar */
private _progression = _object getVariable ["#para_InteractionOverlay_Progress", [-1, [1,1,1,1]]];
if !((_progression#0) isEqualTo -1) then {
	private _progressbar = uiNamespace getVariable ["#para_InteractionOverlay_ProgressBar", controlNull];
	_progressbar progressSetPosition (_progression#0);
	_progressbar ctrlSetTextColor (_progression#1);
};

if (_picture isEqualTo "") then {
	_title ctrlSetPositionX (0.1 * _h);
} else {
	_title ctrlSetPositionX (_h * (3 / 4));
};
_title ctrlCommit 0;

if (_description isEqualTo "") then {
	_body ctrlSetPositionH 0;
	_text ctrlSetPositionH 0;
	_background ctrlSetPositionH 0;
} else {

	_text ctrlSetStructuredText (parseText _description);
	private _height = (ctrlTextHeight _text) + 0.02; // Adjusting because, well because, stop questioning my choices, I'am a developper!

	_group ctrlSetPositionH (_h + _height);
	_body ctrlSetPositionH (_height + 0.02);
	_text ctrlSetPositionH _height;
	_background ctrlSetPositionH (_height + 0.02);
};
{ _x ctrlCommit 0 } forEach [_group, _body, _text, _background];
