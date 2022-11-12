/*
    File: fn_interactionOverlay_setProgress.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Change the object's progress bar state.
    
    Parameter(s):
		_object - Object [OBJECT]
		_progress - Progress from 0 to 1 [NUMBER]
		_color - Color, use [-1,-1,-1,-1] to keep previous one [NUMBER ARRAY(4), defaults to <CURRENT COLOR>]
		_threshold - Threshold from 0 to 1 [NUMBER]
		_thresholdName - Name [STRING]
    
    Returns: nothing
    
    Example(s):
        [cursorObject, 0.5, [1, 0.5, 0, 1], 0.75, "Damages"] call para_c_fnc_interactionOverlay_setProgress;
*/

params [
	["_object", objNull, [objNull]],
	["_progress", -1, [0]],
	["_color", [-1,-1,-1,-1], [[]], [4]],
	["_threshold", 0, [0]],
	["_thresholdName", "", [""]]
];

private _altColor = (_object getVariable ["#para_InteractionOverlay_Progress", [-1, [
	(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),
	(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),
	(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]),
	(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])
]]])#1; 

_color = if ((_color#0) isEqualTo -1) then { _altColor } else { _color };

_object setVariable ["#para_InteractionOverlay_Progress", [_progress, _color, _threshold, _thresholdName]]; 