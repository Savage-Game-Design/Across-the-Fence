#include "\a3\ui_f\hpp\definecommongrids.inc"
// gui grid dimensions
//  40 * GUI_GRID_W
//  25 * GUI_GRID_H

/*
    File: fn_showTabbedTextDialog.sqf
    Author: Savage Game Design
    Date: 2024-07-27
    Last Update: 2024-07-27
    Public: Yes

    Description:
        Shows a simple dialog with multiple tabs of scrollable text.

    Parameter(s):
        _content - Tab name, text pairs. Text can be a string or structured text. [ARRAY]

    Returns:
        Dialog [Display]

    Example(s):
        [
            [
                ["My Tab", "Hello world"],
                ["My other tab", parseText "Hello world again"]
            ]
        ] call vgm_c_fnc_showTabbedTextDialog;
 */

params ["_tabs"];

//----- customize here
private _fnc_drawTextTabOld = {
	params ["_display", "_ctrlContainer", "_containerPosition", "_text"];
	_containerPosition params ["", "", "_w", "_h"];

	private _itemH = 1.5 * GUI_GRID_H;
	{
		private _ctrlText = _display ctrlCreate ["RscText", -1, _ctrlContainer];
		_ctrlText ctrlSetPosition [0, _forEachIndex * _itemH, _w, _itemH];
		_ctrlText ctrlCommit 0;

		_ctrlText ctrlSetText _x;
	} forEach (_text splitString endl);
};

private _fnc_drawTextTab = {
	params ["_display", "_ctrlContainer", "_containerPosition", "_text"];
	_containerPosition params ["", "", "_w", "_h"];

    private _isStructuredText = typeName _text isEqualto "TEXT";
    private _ctrlType = ["RscText", "RscStructuredText"] select _isStructuredText;

    private _ctrlText = _display ctrlCreate [_ctrlType, -1, _ctrlContainer];
    _ctrlText ctrlSetPosition [0, 0, _w, 0];
    _ctrlText ctrlCommit 0;

    if (_isStructuredText) then {
        _ctrlText ctrlSetStructuredText _text;
    } else {
        _ctrlText ctrlSetText _text;
    };
    private _desiredHeight = ctrlTextHeight _ctrlText;
    _ctrlText ctrlSetPosition [0, 0, _w, _desiredHeight];
    _ctrlText ctrlCommit 0;
};

//----- display drawing
private _wTotal = GUI_GRID_CENTER_WAbs;
private _hTotal = GUI_GRID_CENTER_HAbs;
private _hTabs = 2 * GUI_GRID_H;
private _hContent = 23 * GUI_GRID_H;

private _xBase = GUI_GRID_CENTER_X;
private _yBase = GUI_GRID_CENTER_Y;

private _display = createDialog ["RscDisplayEmpty", true];

private _ctrlBg = _display ctrlCreate ["RscText", -1];
_ctrlBg ctrlSetBackgroundColor [0,0,0,0.6];
_ctrlBg ctrlSetPosition [_xBase, _yBase, _wTotal, _hTotal];
_ctrlBg ctrlCommit 0;

private _ctrlTabs = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_ctrlTabs ctrlSetPosition [_xBase, _yBase, _wTotal, _hTabs];
_ctrlTabs ctrlCommit 0;

//----- render tabs and their content
{
	_x params ["_tabName", "_tabText"];

	private _ctrlButtonTab = _display ctrlCreate ["RscButton", -1, _ctrlTabs];
	_ctrlButtonTab ctrlSetText _tabName;
	private _w = _wTotal / count _tabs;
	private _h = _hTabs;
	_ctrlButtonTab ctrlSetPosition [_forEachIndex * _w, 0, _w, _h];
	_ctrlButtonTab ctrlCommit 0;

	_ctrlButtonTab setVariable ["tab_contentPosition", [_xBase, _yBase + _hTabs, _wTotal, _hContent]];
    _ctrlButtonTab setVariable ["tab_text", _tabText];
	_ctrlButtonTab setVariable ["tab_handler", _fnc_drawTextTab];

	private _fnc_tabHandler = {
		params ["_ctrlButton"];
		private _display = ctrlParent _ctrlButton;
		private _position = _ctrlButton getVariable "tab_contentPosition";
		private _fnc_handler = _ctrlButton getVariable "tab_handler";
        private _tabText = _ctrlButton getVariable "tab_text";

		ctrlDelete (_display getVariable ["tab_current", controlNull]);
		private _ctrlContainer = _display ctrlCreate ["RscControlsGroup", -1];
		_ctrlContainer ctrlSetPosition _position;
		_ctrlContainer ctrlCommit 0;
		_display setVariable ["tab_current", _ctrlContainer];

		[_display, _ctrlContainer, _position, _tabText] call _fnc_handler;
	};

	_ctrlButtonTab ctrlAddEventHandler ["ButtonClick", _fnc_tabHandler];
	if (_forEachIndex == 0) then {_ctrlButtonTab call _fnc_tabHandler};
} forEach _tabs;
