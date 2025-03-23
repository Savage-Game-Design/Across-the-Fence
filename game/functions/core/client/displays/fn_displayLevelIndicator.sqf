#include "macros.inc"
/*
    File: fn_displayLevelIndicator.sqf
    Author: Savage Game Design
    Date: 2025-01-05
    Last Update: 2025-01-06
    Public: No

    Description:
        Handles the Level indicator UI.

    Parameter(s):
        _mode - One of the switch-cases [STRING]
        _params - Parameters from the event [ARRAY]

    Returns:
        Nothing [NIL]

    Example(s):
        ["refreshUI", _display] call vgm_c_fnc_displayLevelIndicator;
*/

#define SELF vgm_c_fnc_displayLevelIndicator

#if __A3_DEBUG__
    diag_log ["fn_displayLevelIndicator", _this];
#endif

params ["_mode", ["_params", []]];
_this = _params;

switch _mode do {
    case "onLoad":{
        params ["_display"];
        uiNamespace setVariable ["VGM_RscDisplayLevelIndicator", _display];

        private _refreshHandlersIds = [];
        _display setVariable ["vgm_skills_ui_refreshHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, [_display, {
                params ["", "_display"];
                ["refreshUI", _display] call SELF;
            }]] call para_g_fnc_event_subscribeLocal;

            _refreshHandlersIds pushBack _ehId;
        } forEach [
            "vgm_leveling_updateData"
        ];

        private _fadeOutHandlersIds = [];
        _display setVariable ["vgm_skills_ui_fadeOutHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, {
                ["fadeOut"] call SELF;
            }] call para_g_fnc_event_subscribeLocal;

            _fadeOutHandlersIds pushBack _ehId;
        } forEach [
            "vgm_equipment_arsenalOpen"
        ];

        private _fadeInHandlersIds = [];
        _display setVariable ["vgm_skills_ui_fadeInHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, {
                ["fadeIn"] call SELF;
            }] call para_g_fnc_event_subscribeLocal;

            _fadeInHandlersIds pushBack _ehId;
        } forEach [
            "vgm_equipment_arsenalClose"
        ];

        ["refreshUI", _display] call SELF;
    };

    case "onUnload": {
        params ["_display"];
        {
            [_x] call para_g_fnc_event_unsubscribe;
        } forEach (_display getVariable "vgm_skills_ui_refreshHandlerIds");
        {
            [_x] call para_g_fnc_event_unsubscribe;
        } forEach (_display getVariable "vgm_skills_ui_fadeOutHandlerIds");
        {
            [_x] call para_g_fnc_event_unsubscribe;
        } forEach (_display getVariable "vgm_skills_ui_fadeInHandlerIds");
    };

    case "refreshUI": {
        params ["_display"];

        private _ctrlLevel = _display displayCtrl VGM_IDC_LEVEL_INDICATOR_LEVEL;
        private _ctrlXp = _display displayCtrl VGM_IDC_LEVEL_INDICATOR_XP;

        private _data = player getVariable "vgm_g_levelingData";
        private _currentLevel = _data get "level";
        private _curentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;

        _ctrlLevel ctrlSetText format [localize "STR_VGM_LEVEL_INDICATOR_UI_LEVEL", _curentLevelData get "displayName"];
        _ctrlXp ctrlSetText format [
            localize "STR_VGM_LEVEL_INDICATOR_UI_XP",
            _data get "experience" toFixed 0,
            _curentLevelData get "experienceThreshold"
        ];

        private _xpOffset = vgm_g_leveling_levelsHashMap get (_currentLevel - 1) get "experienceThreshold";
        ["updateXpProgress", [_display, _data get "experience", _curentLevelData get "experienceThreshold", _xpOffset]] call SELF;
    };

    case "updateXpProgress": {
        params ["_display", "_leftXp", "_rightXp", ["_offset", 0]];

        private _ctrlProgress = _display displayCtrl VGM_IDC_LEVEL_INDICATOR_BAR;
        if (_leftXp == _rightXp) exitWith {
            _ctrlProgress progressSetPosition 1;
        };
        _ctrlProgress progressSetPosition ((_leftXp - _offset) / (_rightXp - _offset));
    };

    case "fadeOut": {
        {
            _x ctrlSetFade 1;
            _x ctrlCommit 1;
        } forEach allControls (uiNamespace getVariable ["VGM_RscDisplayLevelIndicator", displayNull]);
    };

    case "fadeIn": {
    {
        _x ctrlSetFade 0;
        _x ctrlCommit 1;
    } forEach allControls (uiNamespace getVariable ["VGM_RscDisplayLevelIndicator", displayNull]);
    };
};
