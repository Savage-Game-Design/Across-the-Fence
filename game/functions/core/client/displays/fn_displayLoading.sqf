/*
    File: fn_displayLoading.sqf
    Author: Savage Game Design
    Date: 2024-11-22
    Last Update: 2024-11-28
    Public: No

    Description:
        Handles custom gamemode loading screen.

    Parameter(s):
        _mode - Determines the part of this function to execute [STRING]
        _this - Parameters for the given _mode [ARRAY]

    Returns:
        nil [NOTHING]

    Example(s):
        ["onLoad", [_display]] call vgm_c_fnc_displayLoading;
 */

#define SELF vgm_c_fnc_displayLoading

params ["_mode", "_this"];

switch _mode do {
    case "onLoad": {
        params ["_display"];

        uiNamespace setVariable ["VGM_DisplayLoading", _display];
        _display setVariable ["VGM_Texts", []];

        private _cfgWorld = configFile >> "CfgWorlds" >> worldName;
        private _worldName = getText (_cfgWorld >> "description");

        private _ctrlHeader = _display displayCtrl 5003;
        private _text = "<t size='1.4'>%1</t><br/><t size='0.8'>%2</t>";
        _text = format [_text, localize "STR_VGM_MISSION_NAME_VERSION", _worldName];
        _ctrlHeader ctrlSetStructuredText parseText _text;

        _display spawn {
            private _ctrlProgress = _this displayCtrl 104;
            waitUntil {
                // Ticker
                format [
                    "%1%2 %3",
                    localize "STR_LOADING",
                    [] call vgm_c_fnc_loading_tickerDots,
                    (_this getVariable ["VGM_Texts", []]) joinString endl
                ] call vgm_c_fnc_loading_setText;

                // Progress bar when injected into other loading screens
                if (!isNull (_this getVariable ["VGM_Parent", displayNull])) then {
                    private _progress = (uiNamespace getVariable ["BIS_fnc_progressloadingscreen_progress", 0]);
                    _ctrlProgress progressSetPosition _progress;
                };

                isNull _this // return
            };
        };
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
