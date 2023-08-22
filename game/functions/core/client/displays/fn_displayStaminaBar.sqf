#include "macros.inc"
/*
    File: fn_displayStaminaBar.sqf
    Author: Savage Game Design
    Date: 2023-08-22
    Last Update: 2023-08-22
    Public: No

    Description:
        UI script for stamina bar HUD.

    Parameter(s):
        _mode - One of the switch-cases [STRING]
        _params - Parameters from the event [ARRAY]

    Returns:
            Nothing

    Example(s):
        ["onLoad", _display] call vgm_c_fnc_displayStaminaBar;
 */

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad":{
        params ["_display"];

        private _ctrlStaminaBarContainer = _display displayCtrl VGM_IDC_STAMINABAR_CONTAINER;
        uiNamespace setVariable ["vgm_stamina_barContainer", _ctrlStaminaBarContainer];

        private _ctrlStaminaBar = _display displayCtrl VGM_IDC_STAMINABAR_BAR;
        uiNamespace setVariable ["vgm_stamina_bar", _ctrlStaminaBar];
        missionNamespace setVariable ["vgm_stamina_barWidth", ctrlPosition _ctrlStaminaBar # 2];

        _ctrlStaminaBarContainer ctrlSetFade 1;
        _ctrlStaminaBarContainer ctrlCommit 0;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
