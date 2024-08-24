#include "macros.inc"
/*
    File: fn_displayNotepad.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-08-24
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

params ["_mode", "_params"];
_this = _params;

#if __A3_DEBUG__
    if (_mode != "renderTooltip") then {
        diag_log ["fn_displayNotepad", _this];
    };
#endif

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
                    _ctrlMap ctrlMapCursor ["Track", _display getVariable ["vgm_cursor_track", ""]];
                };

                ["renderTooltip", _display] call SELF;
            }];

            // handle site marking
            private _ehId = addMissionEventHandler ["MapSingleClick", {
                _thisArgs params ["_display"];
                private _siteId = _display getVariable ["vgm_site_id", ""];
                if (_siteId == "") exitWith {};

                params ["", "_pos"];
                ["markLocationClick", [_display, _pos]] call SELF;
            }, [_display]];
            _display setVariable ["vgm_onMapClickId", _ehId];

            private _ehId = addMissionEventHandler ["Map", {
                _thisArgs params ["_display"];
                params ["_mapOpen"];
                if (_mapOpen) exitWith {};
                ["markLocationDisable", _display] call SELF;
            }, [_display]];
            _display setVariable ["vgm_onMapId", _ehId];
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

        // setup refresh handlers
        private _refreshHandlersIds = [];
        _display setVariable ["vgm_refreshHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, [_display, {
                params ["", "_display"];
                ["refreshUI", _display] call SELF;
            }]] call para_g_fnc_event_subscribeLocal;

            _refreshHandlersIds pushBack _ehId;
        } forEach [
            "vgm_scouting_spottedSiteClient",
            "vgm_scouting_markedSiteClient",
            "vgm_scouting_missedSiteClient",
            "vgm_mission_started",
            "vgm_mission_ended"
        ];
    };

    case "onUnload": {
        params ["_display"];

        {[_x] call para_g_fnc_event_unsubscribe} forEach (_display getVariable "vgm_refreshHandlerIds");

        removeMissionEventHandler ["Map", _display getVariable ["vgm_onMapId", -1]];
        removeMissionEventHandler ["MapSingleClick", _display getVariable ["vgm_onMapClickId", -1]];
    };

    case "refreshUI": {
        params ["_display"];

        private _missionPublic = [] call vgm_c_fnc_missions_getCurrentMission;
        if (isNil "_missionPublic") exitWith {
            (_display getVariable "VGM_RscNotepad") ctrlShow false;
        };

        (_display getVariable "VGM_RscNotepad") ctrlShow true;
        private _ctrlMain = _display getVariable "VGM_RscNotepad_Main";
        // remove old list items
        {ctrlDelete _x} forEach (_ctrlMain getVariable ["vgm_children", []]);
        private _ctrlMainChildren = [];
        _ctrlMain setVariable ["vgm_children", _ctrlMainChildren];

        private _markedSites = _missionPublic get "system_scouting" get "markedSites";
        private _spottedObjects = values (_missionPublic get "system_scouting" get "objects");
        _spottedObjects sort true;

        {
            _x params ["", "_siteName", "_spottedDate", "_siteId", "_pos"];
            private _dateText = format ["%1:%2", _spottedDate#3, _spottedDate#4];

            private _ctrlItem = _display ctrlCreate ["VGM_ctrlStaticNotepad", -1, _ctrlMain];
            // _ctrlItem ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 0.75);
            _ctrlItem ctrlSetPosition [
                0,
                (_forEachIndex+1) * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_W - VGM_NOTEPAD_CONFIRM_W,
                VGM_NOTEPAD_LINE_H
            ];
            // _ctrlItem ctrlSetBackgroundColor [0,1,0,0.25];
            _ctrlItem ctrlCommit 0;

            private _ctrlItemButton = _display ctrlCreate ["VGM_ctrlButtonNotepad", -1, _ctrlMain];
            _ctrlItemButton ctrlSetPosition [
                VGM_NOTEPAD_W - VGM_NOTEPAD_CONFIRM_W,
                (_forEachIndex+1) * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_CONFIRM_W,
                VGM_NOTEPAD_LINE_H
            ];
            // _ctrlItemButton ctrlSetBackgroundColor [0,1,1,0.25];
            _ctrlItemButton ctrlCommit 0;

            _ctrlItem ctrlSetText format ["%1. %2, %3", _forEachIndex+1, localize _siteName, _dateText];
            _ctrlItemButton setVariable ["vgm_id", _siteId];
            _ctrlItemButton setVariable ["vgm_pos", _pos];

            if (_siteId in _markedSites) then {
                _ctrlItemButton ctrlSetText ((_pos call BIS_fnc_posToGrid) joinString " ");
                _ctrlItemButton ctrlSetTooltip "Locate on map";
                _ctrlItemButton ctrlSetFontHeight VGM_NOTEPAD_LINE_H;
                _ctrlItemButton ctrlAddEventHandler ["ButtonClick", {
                    params ["_ctrlButton"];
                    [[500,500], _ctrlButton getVariable "vgm_pos"] call BIS_fnc_zoomOnArea;
                }];
            } else {
                _ctrlItemButton ctrlSetText localize "STR_VGM_MISSIONS_SCOUTING_MARK_LOCATION";
                _ctrlItemButton ctrlAddEventHandler ["ButtonClick", {
                    params ["_ctrlButton"];
                    ["markLocationEnable", [ctrlParent _ctrlButton, _ctrlButton getVariable "vgm_id"]] call SELF;
                }];
            };

            _ctrlMainChildren pushBack _ctrlItem;
            _ctrlMainChildren pushBack _ctrlItemButton;
        } forEach _spottedObjects;
    };

    case "markLocationEnable": {
        params ["_display", "_siteId"];
        _display setVariable ["vgm_cursor_track", "HC_overEnemy"];
        _display setVariable ["vgm_site_id", _siteId];
    };

    case "markLocationDisable": {
        params ["_display"];
        _display setVariable ["vgm_cursor_track", nil];
        _display setVariable ["vgm_site_id", nil];
    };

    case "markLocationClick": {
        params ["_display", "_markedPos"];
        private _siteId = _display getVariable ["vgm_site_id", ""];
        ["vgm_scouting_markSite", [_siteId, _markedPos, player]] call para_g_fnc_event_triggerServer;

        ["markLocationDisable", _display] call SELF;
    };

    case "renderTooltip": {
        params ["_display"];
        private _siteId = _display getVariable ["vgm_site_id", ""];
        private _ctrlTooltip = _display getVariable ["vgm_ctrlTooltip", controlNull];
        if (_siteId == "") exitWith {
            _ctrlTooltip ctrlShow false;
        };

        if (isNull _ctrlTooltip) then {
            _ctrlTooltip = _display ctrlCreate ["RscText", -1];
            _display setVariable ["vgm_ctrlTooltip", _ctrlTooltip];

            _ctrlTooltip ctrlSetText localize "STR_VGM_MISSIONS_SCOUTING_MARK_LOCATION_TOOLTIP";
            _ctrlTooltip ctrlSetBackgroundColor [0, 0, 0, 0.35];
        };

        getMousePosition params ["_x", "_y"];
        _offset = VGM_GRID_W * 2;
        _x = _x + _offset;
        _y = _y + _offset;
        _w = ctrlTextWidth _ctrlTooltip;
        _h = VGM_GRID_H * 5;

        _ctrlTooltip ctrlSetPosition [
            _x min (safeZoneX + safeZoneW - _w),
            _y min (safeZoneY + safeZoneH - _h),
            _w,
            _h
        ];
        _ctrlTooltip ctrlShow true;
        _ctrlTooltip ctrlCommit 0;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
