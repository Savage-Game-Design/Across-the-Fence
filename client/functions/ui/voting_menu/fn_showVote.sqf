/*
	File: fn_showVote.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Shows the VoteOverlay with an animation.

	Parameter(s):
		_duration - Duration of the animation [Number]

	Returns: nothing

	Example(s):
		call para_c_fnc_showVote;
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params [
	["_duration", -1]
];

private _holder = uiNamespace getVariable ['#para_c_VoteoOverlay_Holder', controlNull];
private _body = uiNamespace getVariable ['#para_c_VoteOverlay_Body', controlNull];
private _background = uiNamespace getVariable ['#para_c_VoteOverlay_Background', controlNull];
private _contentControl = uiNamespace getVariable ['#para_c_VoteOverlay_Text', controlNull];
private _primaryControl = uiNamespace getVariable ['#para_c_VoteOverlay_Primary', controlNull];
private _secondaryControl = uiNamespace getVariable ['#para_c_VoteOverlay_Secondary', controlNull];

private _bodyStart = ctrlPosition _body select 1;
private _bodyEnd = (ctrlPosition _body select 1) + (ctrlPosition _body select 3);
private _totalHeight = _bodyEnd - _bodyStart;

private _height = (_totalHeight) max (UIH(1.2));
_holder ctrlSetPositionH (_height + UIH(1.2 + 5));
_holder ctrlCommit _duration;