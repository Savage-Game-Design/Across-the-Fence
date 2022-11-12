/*
    File: fn_interactionOverlay_show.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Shows the Interaction HUD with an animation.
    
    Parameter(s):
        _object - Interactible object [Object, defaults to objNull]
    
    Returns: nothing
    
    Example(s): none
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params [
	["_object", objNull, [objNull]]
];
private _scriptData = _object getVariable ["#para_InteractionOverlay_Data", []];
_scriptData params [
	["_scriptName", "", [""]],
	["_scriptPicture", "", [""]],
	["_scriptDescription", "", [""]],
	["_scriptVariables", {[]}, [{}]],
	["_scriptInteractive", true, [true]]
];

private _main = uiNamespace getVariable ['#para_InteractionOverlay_Main', controlNull];
if (_main isEqualTo controlNull) then {
	call para_c_fnc_interactionOverlay_create;
	waitUntil {
		!((uiNamespace getVariable ['#para_InteractionOverlay_Main', controlNull]) isEqualTo controlNull)
	};
};

private _title = uiNamespace getVariable ['#para_InteractionOverlay_Title', controlNull];
private _action = uiNamespace getVariable ['#para_InteractionOverlay_Action', controlNull];
private _body = uiNamespace getVariable ['#para_InteractionOverlay_Body', controlNull];
if (false in ([_title,_action,_body] apply { ctrlCommitted _x })) exitWith {};

// private _duration = 0.2;
private _duration = 0;

[_object] call para_c_fnc_interactionOverlay_modify;

/* GUI GRIDS VAR */
private _w = UIW(1);
private _h = UIH(1);

/* Progress Bar */
private _progression = _object getVariable ["#para_InteractionOverlay_Progress", [-1, [1,1,1,1], 0, ""]];
if !((_progression#0) isEqualTo -1) then {
	private _progressgrp = uiNamespace getVariable ["#para_InteractionOverlay_Progress", controlNull];
	private _progressthreshold = uiNamespace getVariable ["#para_InteractionOverlay_ProgressThreshold", controlNull];
	private _bodyBg = uiNamespace getVariable ['#para_InteractionOverlay_BodyBackground', controlNull];
	_progressgrp ctrlSetPositionW (21 * _w);
	_progressgrp ctrlCommit _duration;

	_progressgrp progressSetPosition (_progression#2);


	_bodyBg ctrlSetPositionY (0.2 * _h);
	_bodyBg ctrlCommit 0;
};
private _progressthresholdname = uiNamespace getVariable ['#para_InteractionOverlay_TitleThreshold', controlNull];
_progressthresholdname ctrlSetText (_progression#3);
_progressthresholdname ctrlSetTextColor (_progression#1);
_progressthresholdname ctrlCommit 0;

private _gap = [(7 * _w), uiNamespace getVariable ["#para_InteractionOverlay_Gap", 0]] select _scriptInteractive;
_title ctrlSetPositionW ((14 * _w) + _gap);
_title ctrlCommit _duration;
_body ctrlSetPositionW (21 * _w);
_body ctrlCommit _duration;


if (_scriptInteractive) then {
	uiSleep (_duration / 2);
	_action ctrlSetPositionH (1 * _h);
	_action ctrlCommit _duration;
};
missionNamespace setVariable ["#para_InteractionOverlay_Shown", true];