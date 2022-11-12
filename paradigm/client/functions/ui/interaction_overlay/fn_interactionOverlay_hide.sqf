/*
    File: fn_interactionOverlay_hide.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Hides the Interaction HUD with an animation.
    
    Parameter(s): none
    
    Returns: nothing
    
    Example(s): none
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

private _title = uiNamespace getVariable ['#para_InteractionOverlay_Title', controlNull];
private _action = uiNamespace getVariable ['#para_InteractionOverlay_Action', controlNull];
private _body = uiNamespace getVariable ['#para_InteractionOverlay_Body', controlNull];
private _bodyBg = uiNamespace getVariable ['#para_InteractionOverlay_BodyBackground', controlNull];
private _progress = uiNamespace getVariable ["#para_InteractionOverlay_Progress", controlNull];
if (false in ([_title,_action,_body] apply { ctrlCommitted _x })) exitWith {};

// private _duration = 0.2;
private _duration = 0;

_action ctrlSetPositionH 0;
_action ctrlCommit _duration;

uiSleep (_duration / 2);
_title ctrlSetPositionW 0;
_title ctrlCommit _duration;
_body ctrlSetPositionW 0;
_body ctrlCommit _duration;

/* GUI GRIDS VAR */
private _w = UIW(1);
private _h = UIH(1);

_progress ctrlSetPositionW (0 * _w);
_progress ctrlCommit _duration;
uiSleep _duration;
_bodyBg ctrlSetPositionY 0;
_bodyBg ctrlCommit 0;

missionNamespace setVariable ["#para_InteractionOverlay_Shown", false];