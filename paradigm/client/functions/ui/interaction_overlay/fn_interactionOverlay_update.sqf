/*
    File: fn_interactionOverlay_update.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Updates the Interaction HUD.
    
    Parameter(s):
        _object - Interactible object [Object, defaults to objNull]
    
    Returns: nothing
    
    Example(s): none
*/

params [
	["_object", objNull, [objNull]]
];

private _group = uiNamespace getVariable ['#para_InteractionOverlay_Main', controlNull];
/*
private _position = getPosATLVisual _object;

private _box = boundingBox _object;
private _height = abs (_box#0#2 - _box#1#2);

private _playerHeight = (getPosATLVisual player)#2;
private _objectHeight = (_position#2);

_position set [2, _objectHeight min 1.8 min (_playerHeight + 1.5) max (_playerHeight + 2)]; // So it's always at a comfortable height

// Clamping it the the border of the screen
private _screenPos = worldToScreen _position;
if (_screenPos isEqualTo []) then { _screenPos = [-safeZoneX, -safeZoneY] };
if (_screenPos#0 < safeZoneX) then { _screenPos set [0, safeZoneX] };
if (_screenPos#1 < safeZoneY) then { _screenPos set [1, safeZoneY] };
private _screenPlace = (ctrlPosition _group) select [2, 2];
if ((_screenPos#0 + _screenPlace#0) > (safeZoneX + safeZoneW)) then { _screenPos set [0, safeZoneX + safeZoneW - _screenPlace#0] };
if ((_screenPos#1 + _screenPlace#1) > (safeZoneY + safeZoneH)) then { _screenPos set [1, safeZoneY + safeZoneH - _screenPlace#1] };
*/

private _ctrlPosition = ctrlPosition _group;
private _screenPos = [safeZoneX + (safeZoneW / 2) - ((_ctrlPosition#2) / 2), safeZoneY + safeZoneH - _ctrlPosition#3 - (8 * pixelH)];
_group ctrlSetPosition _screenPos;
_group ctrlCommit 0;

/* Progress Bar */
private _progression = _object getVariable ["#para_InteractionOverlay_Progress", [-1, [1,1,1,1]]];
if !((_progression#0) isEqualTo -1) then {
	private _progressbar = uiNamespace getVariable ["#para_InteractionOverlay_ProgressBar", controlNull];
	_progressbar progressSetPosition (_progression#0); 
	_progressbar ctrlSetTextColor (_progression#1);
};

/* Dynamic StructuredText */
if (para_c_InteractionOverlay_Settings_liveText) then {
	private _text = uiNamespace getVariable ['#para_InteractionOverlay_BodyText', controlNull];

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
		["_scriptVariables", {[]}, [{}]]
	];

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
	_text ctrlSetStructuredText (parseText _description);
};

/*
player allowDamage false; player setUnitTrait ["engineer", 1];

private _object = cursorObject;
[_object] call para_c_fnc_interactionOverlay_modify;
*/