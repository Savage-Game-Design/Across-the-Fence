#include "macros.inc"
/*
    File: game/functions/core/client/displays/fn_displayAbilityCooldown.sqf
    Author: Savage Game Design
    Date: 2023-06-14
    Last Update: 2023-05-12
    Public: No

    Description:
            Handles the Ability Cooldown UI.

    Parameter(s):
            _mode - One of the switch-cases [STRING]
            _params - Parameters from the event [ARRAY]

    Returns:
            Nothing [NIL]

    Example(s):
            [] call vgm_c_fnc_displayAbilityCooldown;
*/

#if __A3_DEBUG__
    diag_log ["fn_displayAbilityCooldown", _this];
#endif

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad":{
        params ["_display"];
        uiNamespace setVariable ["VGM_RscDisplayAbilityCooldown", _display];
    };
    case "startCooldown": {
        params ["_skill", "_seconds"];
        private _display = uiNamespace getVariable ["VGM_RscDisplayAbilityCooldown", displayNull];
        if (isNull _display) exitWith {
            ["VGM_RscDisplayAbilityCooldown is not available!"] call BIS_fnc_error;
        };
        private _idcs = [
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNPRIMARY, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSPRIMARY],
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNULTIMATE, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSULTIMATE]
        ] select (_skill == "ulimate");
        (_idcs apply {_display displayCtrl _x}) params ["_ctrlCooldown", "_ctrlSeconds"];
        _ctrlSeconds ctrlSetFade 0;
        _ctrlSeconds ctrlCommit 05;
        private _delta = 0.01;
        for "_i" from 0 to _seconds step _delta do {
            _ctrlCooldown progressSetPosition (1 - _i / _seconds);
            _ctrlSeconds ctrlSetText format ["%1 s", ceil (_seconds - _i)];
            uiSleep _delta;
        };
        _ctrlSeconds ctrlSetText "0 s";
        _ctrlSeconds ctrlSetFade 1;
        _ctrlSeconds ctrlCommit 3;
    };
};
