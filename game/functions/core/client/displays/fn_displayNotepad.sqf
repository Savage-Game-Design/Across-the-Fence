#include "macros.inc"
/*
    File: fn_displayNotepad.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-08-18
    Public: No

    Description:
        UI script for the scouting notepad UI.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        [parameter] call vgm_c_fnc_displayNotepad
 */

#define SELF vgm_c_fnc_displayNotepad

#if __A3_DEBUG__
    diag_log ["fn_displayNotepad", _this];
#endif

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad": {
        params ["_ctrlObject"];
        private _display = ctrlParent _ctrlObject;
        private _mapDisplay = findDisplay 12;

        _display setVariable ["VGM_RscNotepad", _ctrlObject];
        private _ctrlGrpMain = _display getVariable "VGM_RscNotepad_Main";

        // change cursor when dragging is possible
        if (_display == _mapDisplay) then {
            _ctrlObject ctrlAddEventHandler ["MouseMoving", {
                params ["_ctrl"];
                ctrlParent _ctrl setVariable ["vgm_cursor_arrow", "Move"];
            }];

            _ctrlGrpMain ctrlAddEventHandler ["MouseMoving", {
                params ["_ctrl"];
                ctrlParent _ctrl setVariable ["vgm_cursor_arrow", ""];
            }];

            // update the cursor via Map control
            (_display displayCtrl 51) ctrlAddEventHandler ["Draw", {
                params ["_ctrlMap"];
                private _display = ctrlParent _ctrlMap;
                private _ctrlFocused = _display ctrlAt getMousePosition;

                if ((_display getVariable "VGM_RscNotepad") == _ctrlFocused) then {
                    _ctrlMap ctrlMapCursor ["Arrow", _display getVariable ["vgm_cursor_arrow", ""]];
                } else {
                    _ctrlMap ctrlMapCursor ["Arrow", ""];
                }
            }];
        };

        // debug background
        if (false) then {
            private _ctrlBg = _display ctrlCreate ["VGM_ctrlStatic", -1, _ctrlGrpMain];
            _ctrlBg ctrlSetBackgroundColor [1,0,0,0.35];
            _ctrlBg ctrlSetPosition [0, 0, VGM_NOTEPAD_W, VGM_NOTEPAD_H];
            _ctrlBg ctrlCommit 0;
        };

        private _ctrlHeader = _display ctrlCreate ["VGM_ctrlStaticNotepadHeader", -1, _ctrlGrpMain];
        _ctrlHeader ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 1.8);
        _ctrlHeader ctrlSetText toUpper "Scouting report";
        _ctrlHeader ctrlSetPosition [0, -(2 * VGM_NOTEPAD_GRID_H), VGM_NOTEPAD_W, VGM_NOTEPAD_LINE_H + (1.5 * VGM_NOTEPAD_GRID_H)];
        _ctrlHeader ctrlEnable false;
        _ctrlHeader ctrlCommit 0;

        ["refreshUI", _display] call SELF;
    };

    case "refreshUI": {
        params ["_display"];

        if (isNil {[] call vgm_c_fnc_missions_getCurrentMission}) exitWith {
            (_display getVariable "VGM_RscNotepad") ctrlShow false;
        };

        private _ctrlMain = _display getVariable "VGM_RscNotepad_Main";

        {
            private _ctrlHeader = _display ctrlCreate ["VGM_ctrlStaticNotepad", -1, _ctrlGrpMain];
            _ctrlHeader ctrlSetFontHeight VGM_NOTEPAD_LINE_H;
            _ctrlHeader ctrlSetText str _x;
            _ctrlHeader ctrlSetPosition [0, (_forEachIndex+1) * VGM_NOTEPAD_LINE_H, VGM_NOTEPAD_W, VGM_NOTEPAD_LINE_H];
            _ctrlHeader ctrlSetBackgroundColor [0,1,0,0.35];
            _ctrlHeader ctrlCommit 0;
        } forEach [1,2,3,4,5];
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
