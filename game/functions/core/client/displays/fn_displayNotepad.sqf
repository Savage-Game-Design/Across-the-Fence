#include "macros.inc"
/*
    File: fn_displayNotepad.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2025-02-17
    Public: No

    Description:
        UI script for the scouting notepad UI.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        ["refreshUI", findDisplay 12] call vgm_c_fnc_displayNotepad
 */

#define SELF vgm_c_fnc_displayNotepad

params ["_mode", "_params"];
_this = _params;

#if __A3_DEBUG__
    if (_mode != "renderTooltip") then {
        diag_log ["fn_displayNotepad", _mode, _this];
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
        /*
        private _ctrlBg = _display ctrlCreate ["VGM_ctrlStatic", -1, _ctrlGrpMain];
        _ctrlBg ctrlSetBackgroundColor [1,0,0,0.35];
        _ctrlBg ctrlSetPosition [0, 0, VGM_NOTEPAD_W, VGM_NOTEPAD_H];
        _ctrlBg ctrlCommit 0;
        */

        private _ctrlHeader = _display ctrlCreate ["VGM_ctrlStaticNotepadHeader", -1, _ctrlGrpMain];
        _ctrlHeader ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 1.8);
        _ctrlHeader ctrlSetText toUpper localize "STR_VGM_MISSIONS_SCOUTING_REPORT";
        _ctrlHeader ctrlSetPosition [
            0,
            -(2 * VGM_NOTEPAD_GRID_H),
            VGM_NOTEPAD_W,
            VGM_NOTEPAD_LINE_H + (1.5 * VGM_NOTEPAD_GRID_H)
        ];
        _ctrlHeader ctrlEnable false;
        _ctrlHeader ctrlCommit 0;

        private _ctrlHelp = _display ctrlCreate ["VGM_ctrlButtonNotepadHelp", -1, _ctrlGrpMain];
        _ctrlHelp ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 1);
        _ctrlHelp ctrlSetPosition [
            VGM_NOTEPAD_W - (4 * VGM_NOTEPAD_GRID_H),
            2 * VGM_NOTEPAD_GRID_H,
            4 * VGM_NOTEPAD_GRID_H,
            4 * VGM_NOTEPAD_GRID_H
        ];
        _ctrlHelp ctrlCommit 0;

        ["refreshUI", _display] call SELF;

        // setup refresh handlers
        private _refreshHandlersIds = [];
        _display setVariable ["vgm_refreshHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, [_display, {
                params ["", "_display"];
                ["refreshUI", _display] call SELF;
            }]] call para_g_fnc_event_subscribe;

            _refreshHandlersIds pushBack _ehId;
        } forEach [
            "vgm_scouting_addedSiteClient",
            "vgm_scouting_spottedSiteClient",
            "vgm_scouting_siteTypeChangedClient",
            "vgm_scouting_sitePhotoChangedClient",
            "vgm_scouting_markedSiteClient",
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
            (_display getVariable "VGM_RscNotepad") ctrlShow is3DENPreview;
        };

        (_display getVariable "VGM_RscNotepad") ctrlShow true;
        private _ctrlMain = _display getVariable "VGM_RscNotepad_Main";
        // remove old list items
        {ctrlDelete _x} forEach (_ctrlMain getVariable ["vgm_children", []]);
        private _ctrlMainChildren = [];
        _ctrlMain setVariable ["vgm_children", _ctrlMainChildren];

        private _data = _missionPublic get "system_scouting";
        private _guessedSites = _data get "guessedSites";

        private _isPhotoMode = createHashMap isNotEqualTo (_display getVariable ["vgm_site_photoData", createHashMap]);

        private _lastIndex = -1;
        {
            _x params ["", "_siteType", "_spottedDate", "_pos", "_siteId", "_photoData"];
            // TODO refactor into function
            private _siteName = (vgm_scouting_siteTypes param [vgm_scouting_siteTypes findIf {(_x#1) == _siteType}]) param [0, _siteType];

            private _minutes = if (_spottedDate#4 < 10) then {format ["0%1", _spottedDate#4]} else {_spottedDate#4};
            private _dateText = format ["%1:%2", _spottedDate#3, _minutes];
            private _lineIndex = _forEachIndex+1; // header takes line 0

        //------------------- Add index text
            private _ctrlIndex = _display ctrlCreate ["VGM_ctrlStaticNotepad", -1, _ctrlMain];
            _ctrlMainChildren pushBack _ctrlIndex;
            // _ctrlItem ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 0.75);
            _ctrlIndex ctrlSetPosition [
                0,
                _lineIndex * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_INDEX_W,
                VGM_NOTEPAD_LINE_H
            ];
            _ctrlIndex ctrlCommit 0;
            _ctrlIndex ctrlSetText format ["%1.", _lineIndex];

        //------------------- Add button to edit site type
            private _buttonClass = ["VGM_ctrlButtonPictureKeepAspectNotepad", "VGM_ctrlButtonPictureKeepAspectNotepadDisabled"] select _isPhotoMode;
            private _ctrlItemButtonType = _display ctrlCreate [_buttonClass, -1, _ctrlMain];
            _ctrlMainChildren pushBack _ctrlItemButtonType;
            _ctrlItemButtonType ctrlSetPosition [
                VGM_NOTEPAD_INDEX_W,
                _lineIndex * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_BTN_SMALL_W,
                VGM_NOTEPAD_LINE_H
            ];
            _ctrlItemButtonType ctrlCommit 0;

            _ctrlItemButtonType setVariable ["vgm_id", _siteId];
            _ctrlItemButtonType setVariable ["vgm_index", _forEachIndex];

            _ctrlItemButtonType ctrlSetText "\a3\ui_f\data\GUI\RscCommon\RscButtonSearch\search_start_ca.paa";

            if (_isPhotoMode) then {
            } else {
                _ctrlItemButtonType ctrlAddEventHandler ["ButtonClick", {
                    params ["_ctrlButton"];
                    ["setLocationTypeEnable", [_ctrlButton, _ctrlButton getVariable "vgm_id"]] call SELF;
                }];
            };

        //------------------- Add site type text
            private _ctrlItem = _display ctrlCreate ["VGM_ctrlStaticNotepad", -1, _ctrlMain];
            _ctrlMainChildren pushBack _ctrlItem;
            // _ctrlItem ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 0.75);
            _ctrlItem ctrlSetPosition [
                VGM_NOTEPAD_INDEX_W + VGM_NOTEPAD_BTN_SMALL_W,
                _lineIndex * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_W - VGM_NOTEPAD_INDEX_W - VGM_NOTEPAD_CONFIRM_W - VGM_NOTEPAD_BTN_SMALL_W_PADDED - VGM_NOTEPAD_BTN_SMALL_W_PADDED,
                VGM_NOTEPAD_LINE_H
            ];
            // _ctrlItem ctrlSetBackgroundColor [0,1,0,0.25];
            _ctrlItem ctrlCommit 0;
            if (_siteType isEqualTo "") then {
                _ctrlItem ctrlSetText localize "STR_VGM_MISSIONS_SCOUTING_SITE_TYPE_UNKNOWN";
            } else {
                _ctrlItem ctrlSetText format ["%1, %2", _siteName, _dateText];
            };

        //------------------- Add button to assign a photo
            private _buttonClass = [
                "VGM_ctrlButtonPictureKeepAspectNotepadDisabled",
                "VGM_ctrlButtonPictureKeepAspectNotepad"
            ] select (_isPhotoMode || _photoData isNotEqualTo createHashMap);
            private _ctrlItemButtonPhoto = _display ctrlCreate [_buttonClass, -1, _ctrlMain];
            _ctrlMainChildren pushBack _ctrlItemButtonPhoto;

            _ctrlItemButtonPhoto ctrlSetPosition [
                VGM_NOTEPAD_W - VGM_NOTEPAD_CONFIRM_W - VGM_NOTEPAD_BTN_SMALL_W_PADDED,
                _lineIndex * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_BTN_SMALL_W,
                VGM_NOTEPAD_LINE_H
            ];
            _ctrlItemButtonPhoto ctrlCommit 0;

            _ctrlItemButtonPhoto setVariable ["vgm_id", _siteId];
            _ctrlItemButtonPhoto setVariable ["vgm_index", _forEachIndex];

            if (_isPhotoMode) then {
                _ctrlItemButtonPhoto ctrlSetText getMissionPath "assets\notepad\cam_add_ca.paa";
                _ctrlItemButtonPhoto ctrlAddEventHandler ["ButtonClick", {
                    params ["_ctrlButton"];
                    ["assignPhoto", [_ctrlButton, _ctrlButton getVariable "vgm_id"]] call SELF;
                }];
            } else {
                if (_photoData isEqualTo createHashMap) exitWith {
                    _ctrlItemButtonPhoto ctrlSetText getMissionPath "assets\notepad\cam_empty_ca.paa";
                    ["setTooltip", [_ctrlItemButtonPhoto, "No photo"]] call SELF;
                };

                _ctrlItemButtonPhoto ctrlSetText getMissionPath "assets\notepad\cam_ca.paa";
                ["setTooltip", [_ctrlItemButtonPhoto, "Has photo"]] call SELF;
            };

        //------------------- Add button to edit site position
            private _ctrlItemButtonGrid = _display ctrlCreate ["VGM_ctrlButtonNotepad", -1, _ctrlMain];
            _ctrlMainChildren pushBack _ctrlItemButtonGrid;
            _ctrlItemButtonGrid ctrlSetPosition [
                VGM_NOTEPAD_W - VGM_NOTEPAD_CONFIRM_W,
                _lineIndex * VGM_NOTEPAD_LINE_H,
                VGM_NOTEPAD_CONFIRM_W,
                VGM_NOTEPAD_LINE_H
            ];
            _ctrlItemButtonGrid ctrlSetBackgroundColor [0,0,0,0.05];
            _ctrlItemButtonGrid ctrlCommit 0;

            _ctrlItemButtonGrid setVariable ["vgm_id", _siteId];
            _ctrlItemButtonGrid setVariable ["vgm_pos", _pos];

            if (_pos isEqualTo []) then {
                // no location set
                _ctrlItemButtonGrid ctrlSetText localize "STR_VGM_MISSIONS_SCOUTING_MARK_LOCATION";
                _ctrlItemButtonGrid ctrlAddEventHandler ["ButtonClick", {
                    params ["_ctrlButton"];
                    ["markLocationEnable", [ctrlParent _ctrlButton, _ctrlButton getVariable "vgm_id"]] call SELF;
                }];

                _ctrlItemButtonGrid ctrlEnable !_isPhotoMode;
            } else {
                // location set
                _ctrlItemButtonGrid ctrlSetText ((_pos call BIS_fnc_posToGrid) joinString " ");
                _ctrlItemButtonGrid ctrlSetFontHeight VGM_NOTEPAD_LINE_H;

                // left mouse to focus
                _ctrlItemButtonGrid ctrlAddEventHandler ["MouseButtonClick", {
                    params ["_ctrlButton", "_mouseButton"];
                    if (_mouseButton != 0) exitWith {};
                    [[500,500], _ctrlButton getVariable "vgm_pos"] call BIS_fnc_zoomOnArea;
                }];

                if (!_isPhotoMode) then {
                    // right mouse to change location
                    _ctrlItemButtonGrid ctrlAddEventHandler ["MouseButtonClick", {
                        params ["_ctrlButton", "_mouseButton"];
                        if (_mouseButton != 1) exitWith {};
                        ["markLocationEnable", [ctrlParent _ctrlButton, _ctrlButton getVariable "vgm_id"]] call SELF;
                    }];
                    ["setTooltip", [_ctrlItemButtonGrid, "Left click to focus, right click to edit"]] call SELF;
                };
            };
            _lastIndex = _forEachIndex;
        } forEach _guessedSites;

        if (count _guessedSites < (_data get "guessedSitesMax")) then {
            ["adjustAddSiteRow", [_display, _lastIndex]] call SELF;
        };
    };

    case "adjustAddSiteRow": {
        params ["_display", "_lastIndex"];
        private _lineIndex = _lastIndex + 2;

        private _ctrlAddItem = _display ctrlCreate ["VGM_ctrlButtonNotepad", -1, _ctrlMain];
        _ctrlMainChildren pushBack _ctrlAddItem;
        _ctrlAddItem ctrlSetPosition [
            0,
            _lineIndex * VGM_NOTEPAD_LINE_H,
            VGM_NOTEPAD_INDEX_W + VGM_NOTEPAD_BTN_SMALL_W,
            VGM_NOTEPAD_LINE_H
        ];
        _ctrlAddItem ctrlCommit 0;
        _ctrlAddItem ctrlSetText localize "STR_VGM_MISSIONS_SCOUTING_ADD_ITEM";

        _ctrlAddItem ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrlButton"];
            ["vgm_scouting_addSite", [player]] call para_g_fnc_event_triggerServer;
        }];
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

        private _mission = [] call vgm_c_fnc_missions_getCurrentMission;
        if !(_markedPos inArea (_mission call vgm_g_fnc_missions_getZoneMarker)) exitWith {
            playSoundUI ["3DEN_notificationWarning", 0.5];
        };

        private _siteId = _display getVariable ["vgm_site_id", ""];
        ["vgm_scouting_markSite", [_siteId, _markedPos, player]] call para_g_fnc_event_triggerServer;

        ["markLocationDisable", _display] call SELF;
    };

    case "setLocationTypeEnable": {
        params ["_ctrlButton", "_siteId"];
        private _display = ctrlParent _ctrlButton;
        private _ctrlObject = _display getVariable "VGM_RscNotepad";

        ctrlPosition _ctrlObject params ["", "_z", ""];
        private _scale = 1 - _z;

        getMousePosition params ["_x", "_y"];
        private _w = (VGM_NOTEPAD_W - VGM_NOTEPAD_CONFIRM_W * 1.4) * _scale;
        private _h = (VGM_NOTEPAD_LINE_H) * _scale;

        private _ctrlCombo = _display ctrlCreate ["VGM_ctrlListBoxNotepad", -1];
        _ctrlCombo ctrlSetPosition [_x, _y, _w, (_h * 10)];
        _ctrlCombo ctrlCommit 0;
        _ctrlCombo ctrlSetFontHeight (VGM_NOTEPAD_LINE_H * 0.52 * _scale);

        ctrlSetFocus _ctrlCombo;
        _ctrlCombo ctrlAddEventHandler ["KillFocus", {
            params ["_ctrlCombo"];
            ctrlDelete _ctrlCombo;
        }];

        _ctrlCombo setVariable ["vgm_id", _siteId];
        _ctrlCombo ctrlAddEventHandler ["LbSelChanged", {
            params ["_ctrlCombo", "_lbCurSel"];
            private _siteId = _ctrlCombo getVariable "vgm_id";
            ["vgm_scouting_setSiteType", [_siteId, _ctrlCombo lbData _lbCurSel, player]] call para_g_fnc_event_triggerServer;
            _ctrlCombo spawn {uiSleep 0.1; ctrlDelete _this};
        }];

        //----- fill list with data
        {
            _x params ["_siteName", "_siteType", "_locationClass"];
            private _icon = getText (configFile >> "CfgLocationTypes" >> _locationClass >> "texture");
            private _iconColor = getArray (configFile >> "CfgLocationTypes" >> _locationClass >> "color");
            _iconColor = _iconColor apply {if (_x isEqualType "") then {call compile _x} else {_x}}; // convert profile namespace colors to numbers

            private _idx = _ctrlCombo lbAdd _siteName;
            _ctrlCombo lbSetData [_idx, _siteType];

            _ctrlCombo lbSetPictureRight [_idx, _icon];
            if (_iconColor isNotEqualTo []) then {_ctrlCombo lbSetPictureRightColor [_idx, _iconColor]};
        } forEach vgm_scouting_siteTypes;
    };

    case "assignPhoto": {
        params ["_ctrlButton", "_siteId"];
        private _display = ctrlParent _ctrlButton;

        private _photoData = _display getVariable "vgm_site_photoData";
        if (isNil "_photoData") exitWith {
            "Invalid photo data" call vgm_g_fnc_logError;
        };

        // disable "photo mode"
        _display setVariable ["vgm_site_photoData", nil];

        ["vgm_scouting_setSitePhoto", [_siteId, _photoData, player]] call para_g_fnc_event_triggerServer;
    };

    /*
        Setups scripted tooltip on a control.
        Native engine tooltips do not work in 3D object controls.
    */
    case "setTooltip": {
        params ["_ctrl", "_tooltip"];

        _ctrl setVariable ["vgm_tooltip", _tooltip];
        _ctrl ctrlAddEventHandler ["MouseMoving", {
            params ["_ctrl", "", "", "_isOver"];
            private _setScript = _ctrl getVariable ["vgm_tooltipScript", scriptNull];

            if (_isOver && isNull _setScript) exitWith {
                _ctrl setVariable ["vgm_tooltipScript", _ctrl spawn {
                    uiSleep 0.5;
                    ctrlParent _this setVariable ["vgm_tooltip", _this getVariable "vgm_tooltip"];
                }];
            };
            if (!_isOver) then {
                terminate _setScript;
                ctrlParent _ctrl setVariable ["vgm_tooltip", nil];
            };
        }];
    };

    /*
        Handle rendering of custom scripted tooltips.
    */
    case "renderTooltip": {
        params ["_display"];
        private _ctrlTooltip = _display getVariable ["vgm_ctrlTooltip", controlNull];

        private _siteId = _display getVariable ["vgm_site_id", ""];
        private _sitePhoto = _display getVariable ["vgm_site_photoData", createHashMap];
        private _hoverTooltip = _display getVariable ["vgm_tooltip", ""];

        if (
            _siteId isEqualTo ""
            && (_hoverTooltip isEqualTo "")
            && (_sitePhoto isEqualTo createHashMap)
        ) exitWith {
            _ctrlTooltip ctrlShow false;
        };

        if (isNull _ctrlTooltip) then {
            _ctrlTooltip = _display ctrlCreate ["RscText", -1];
            _display setVariable ["vgm_ctrlTooltip", _ctrlTooltip];
            _ctrlTooltip ctrlSetBackgroundColor [0, 0, 0, 0.35];
        };

        private _text = call {
            if (_siteId isNotEqualTo "") exitWith {
                localize "STR_VGM_MISSIONS_SCOUTING_MARK_LOCATION_TOOLTIP" // return
            };
            if (_sitePhoto isNotEqualTo createHashMap) exitWith {
                "Select site from the list to assign a photo" // return
            };

            _hoverTooltip // return
        };

        _ctrlTooltip ctrlSetText _text;

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
