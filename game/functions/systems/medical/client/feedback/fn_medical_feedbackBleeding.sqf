#include "script_component.inc"
/*
    File: fn_medical_feedbackBleeding.sqf
    Author: Savage Game Design
    Date: 2023-07-15
    Last Update: 2025-09-10
    Public: No

    Description:
        Handle feedback effects for player bleeding.

    Parameter(s):
        _remainingTime - Remaining player bleed out time, -1 to hide the overlay [NUMBER]

    Returns:
        Nothing

    Example(s):
        15 call vgm_c_fnc_medical_feedbackBleeding
 */

params ["_remainingTime"];

private _display = uiNamespace getVariable "vgm_RscHealthTextures";

private _texUpper = _display displayctrl 1213; // smaller bloodstains at the edges
private _texMiddle = _display displayctrl 1212; // bigger bloodstains all around the screen
private _texLower = _display displayctrl 1211; // more uniform color overlay

// fade out the overlay
if (_remainingTime < 0) exitWith {
    _texLower ctrlSetFade 1;
    _texMiddle ctrlSetFade 1;
    _texUpper ctrlSetFade 1;

    _texLower ctrlCommit 3;
    _texMiddle ctrlCommit 3;
    _texUpper ctrlCommit 3;
};

// set intensity of the overlay based on remaining bleed out time
_texLower ctrlSetFade (linearConversion [BLEED_OUT_TIME, 10, _remainingTime, 0.6, 0, true]);
_texMiddle ctrlSetFade (linearConversion [BLEED_OUT_TIME, 10, _remainingTime, 1, 0, true]);
_texUpper ctrlSetFade (linearConversion [BLEED_OUT_TIME, 10, _remainingTime, 1, 0.45, true]);

_texLower ctrlCommit 0;
_texMiddle ctrlCommit 0;
_texUpper ctrlCommit 0;
