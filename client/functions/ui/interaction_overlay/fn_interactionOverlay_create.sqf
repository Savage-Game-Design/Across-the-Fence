/*
    File: fn_interactionOverlay_create.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Creates the Interaction HUD main dialog.
    
    Parameter(s): none
    
    Returns: nothing
    
    Example(s): none
*/

"Para_InteractionOverlay" cutRsc ["para_InteractionOverlay", "PLAIN", -1, false];

// Calculating HUD positions
private _text = uiNamespace getVariable ['#para_InteractionOverlay_ActionText', controlNull];
private _interactionKey = uiNamespace getVariable ['#para_InteractionOverlay_InteractionKey', controlNull];
private _width = ctrlTextWidth _text;
private _keyPosition = ctrlPosition _interactionKey;
private _interaction = uiNamespace getVariable ['#para_InteractionOverlay_Action', controlNull];
private _position = ctrlPosition _interaction;
private _newWidth = _width + (_keyPosition#2);
_interaction ctrlSetPositionW _newWidth;
_interaction ctrlSetPositionX ((_position#0) + (_position#2) - _newWidth);
_interaction ctrlCommit 0;
uiNamespace setVariable ["#para_InteractionOverlay_Gap", (_position#2) - _newWidth];
uiNamespace setVariable ["#para_InteractionOverlay_ModifiedPosition", [((_position#0) + (_position#2) - _newWidth), _newWidth]];