#include "macros.inc"
/*
    File: fn_displayAbilityCooldown.sqf
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
            ["startCooldown", ["ultimate", 20]] call vgm_c_fnc_displayAbilityCooldown;
*/

#define SELF vgm_c_fnc_displayAbilityCooldown
#define SLOT_STANDARD "ability1"
#define SLOT_ULTIMATE "ultimate"

#if __A3_DEBUG__
    diag_log ["fn_displayAbilityCooldown", _this];
#endif

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad":{
        params ["_display"];
        uiNamespace setVariable ["VGM_RscDisplayAbilityCooldown", _display];

        private _handlerId = ["vgm_skills_active_slotted", [_display, {
            params ["", "_display"];
            ["refreshUI", _display] call SELF;
        }]] call para_g_fnc_event_subscribeLocal;
        _display setVariable ["vgm_skills_ui_skillSlottedHandlerId", _handlerId];

        ["refreshUI"] call SELF;
    };

    case "onUnload": {
        params ["_display"];
        [_display getVariable "vgm_skills_ui_skillSlottedHandlerId"] call para_g_fnc_event_unsubscribe;
    };

    case "refreshUI": {
        private _display = uiNamespace getVariable ["VGM_RscDisplayAbilityCooldown", displayNull];

        {
            _x params ["_idcIcon", "_slotName"];

            private _slot = vgm_c_skills_active_slots get _slotName;
            private _skill = _slot get "skill";

            (_display displayCtrl _idcIcon) ctrlSetText (_skill getOrDefault [
                "icon",
                "\a3\ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa"
            ]);
        } forEach [
            [VGM_IDC_RSCABILITYCOOLDOWN_ICONPRIMARY, SLOT_STANDARD],
            [VGM_IDC_RSCABILITYCOOLDOWN_ICONULTIMATE, SLOT_ULTIMATE]
        ];
    };

    case "startCooldown": {
        params ["_skill", "_seconds"];

        private _display = uiNamespace getVariable ["VGM_RscDisplayAbilityCooldown", displayNull];
        if (isNull _display) exitWith {
            ["Ability cooldown HUD not available"] call vgm_g_fnc_logError;
        };

        private _idcs = [
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNPRIMARY, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSPRIMARY],
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNULTIMATE, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSULTIMATE]
        ] select (_skill == SLOT_ULTIMATE);

        (_idcs apply {_display displayCtrl _x}) params ["_ctrlCooldown", "_ctrlSeconds"];
        _ctrlSeconds ctrlSetFade 0;
        _ctrlSeconds ctrlCommit 5;

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
