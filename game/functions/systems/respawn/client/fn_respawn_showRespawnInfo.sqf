#include "\a3\ui_f\hpp\definecommongrids.inc"
/*
    File: fn_respawn_showRespawnInfo.sqf
    Author: Savage Game Design
    Date: 2025-01-17
    Last Update: 2025-01-19
    Public: No

    Description:
        Script responsible for showing the respawn summary screen.

    Parameter(s):
        None

    Returns:
        Something [BOOL]

    Example(s):
        [[]] call vgm_c_fnc_respawn_showRespawnInfo
 */

disableSerialization;
params ["_lostItems"];

_lostItems = +_lostItems;
_lostItems sort false;

private _fnc_itemText = {
    params ["_count", "_class"];
    private _config = _class call vgm_g_fnc_itemConfig;
    format ["%2 x %1", getText (_config >> "displayName"), _count] // return
};

"vgm_respawn_info" cutRsc ["RscTitleDisplayEmpty", "PLAIN", 0.001];
private _display = uiNamespace getVariable "RscTitleDisplayEmpty";
uiNamespace setVariable ["RscTitleDisplayEmpty", nil];

private _w = GUI_GRID_W * 40;
private _h = GUI_GRID_H * 2;

private _ctrlHeader = _display ctrlCreate ["RscText", -1];
_ctrlHeader ctrlSetPosition [0.5 - _w/2, 0.5 - _h/2 - _h*4.5, _w, _h];
_ctrlHeader ctrlSetFade 1;
_ctrlHeader ctrlCommit 0;

private _ctrlHeaderItems = _display ctrlCreate ["RscText", -1];
_ctrlHeaderItems ctrlSetPosition [0.5 - _w/2, 0.5 - _h/2 -_h*3, _w, _h];
_ctrlHeaderItems ctrlSetFade 1;
_ctrlHeaderItems ctrlCommit 0;

private _ctrlItemsList = _display ctrlCreate ["RscStructuredText", -1];
_ctrlItemsList ctrlSetPosition [0.5 - _w/2, 0.5 - _h/2 -_h*2, _w, _h * 8];
_ctrlItemsList ctrlSetFade 1;
_ctrlItemsList ctrlCommit 0;

_ctrlHeader ctrlSetText localize "STR_VGM_RESPAWN_UI_SUMMARY_HEADER";
_ctrlHeader ctrlSetFontHeight _h*0.8;
_ctrlHeaderItems ctrlSetText localize "STR_VGM_RESPAWN_UI_SUMMARY_ITEMS_HEADER";
_ctrlHeaderItems ctrlSetFontHeight _h*0.55;
private _text = _lostItems apply {_x call _fnc_itemText} joinString "<br/>";
_ctrlItemsList ctrlSetStructuredText parseText _text;

_ctrlHeader ctrlSetFade 0;
if (count _lostItems > 0) then {
    {_x ctrlSetFade 0} forEach [_ctrlHeaderItems, _ctrlItemsList];
};

_ctrlHeader ctrlCommit 3;
waitUntil {ctrlCommitted _ctrlHeader};
_ctrlHeaderItems ctrlCommit 3;
_ctrlItemsList ctrlCommit 5;
waitUntil {ctrlCommitted _ctrlItemsList};

{_x ctrlSetFade 1; _x ctrlCommit (3 * _forEachIndex+1)} forEach [_ctrlHeader, _ctrlHeaderItems, _ctrlItemsList];
uiSleep 3;
waitUntil {ctrlCommitted _ctrlItemsList};
"vgm_respawn_info" cutFadeOut 1;
