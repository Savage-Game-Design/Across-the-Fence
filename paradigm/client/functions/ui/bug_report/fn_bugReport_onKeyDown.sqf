/**
    File: fn_bugReport_onKeyDown.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Handles key down.
        Must be spawned
    
    Parameter(s): (see onKeyDown event on the wiki)
    
    Returns: nothing
    
    Example(s):
		[...] spawn para_c_fnc_bugReport_show;
*/

#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "..\..\..\configs\ui\ui_def_base.inc"
#define para_RscDisplayBuildingMenu_headerHeight (UIH(1))
#define para_RscDisplayBuildingMenu_gutterHeight (UIH(0.1))
#define para_RscDisplayBuildingMenu_gutterWidth (UIW(0.1))
#define para_RscDisplayBuildingMenu_backgroundHeight (UIH(25) - para_RscDisplayBuildingMenu_headerHeight - para_RscDisplayBuildingMenu_gutterHeight)
#define para_RscDisplayBuildingMenu_paddingHeight (UIH(0.5))
#define para_RscDisplayBuildingMenu_paddingWidth (UIW(0.5))

params ["_control", "_key", "_shift", "_ctrl", "_alt"];
uiSleep diag_deltaTime;
private _display = ctrlParent _control;
private _ctrlDummy = _display displayCtrl 50;
private _ctrlGroup = _display displayCtrl 40;


private _text = ctrlText _control;


private _selection = ctrlTextSelection _control;
_selection params ["_selStart", "_selLen", "_selText"];
private _beforeStart = 0;
private _beforeEnd = if (_selLen >= 0) then { _selStart } else { _selStart + _selLen };
private _afterStart = if (_selLen >= 0) then { _selStart + _selLen } else { _selStart };

private _before = _text select [_beforeStart, _beforeEnd];
private _after = _text select [_afterStart];


private _isNewLine = _key in [DIK_RETURN, DIK_NUMPADENTER];
if (_isNewLine) exitWith {
    private _newText = _before + (toString [10]) + _after;
    _text = _newText;
    _control ctrlSetText _text;
    _control ctrlSetTextSelection [_beforeEnd + 1, 0];
};

_ctrlDummy ctrlSetText _before + (["", toString [10]] select _isNewLine);
private _height = ctrlTextHeight _control;

private _minHeight = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - para_RscDisplayBuildingMenu_gutterHeight * 2;
_control ctrlSetPositionH ((_height + UIH(1)) max _minHeight);
_control ctrlCommit 0;