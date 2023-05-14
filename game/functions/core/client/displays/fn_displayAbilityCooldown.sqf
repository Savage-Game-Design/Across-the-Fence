#include "macros.inc"
/*
    File: fn_displayAbilityCooldown.sqf
    Author: Savage Game Design
    Date: 2023-06-14
    Last Update: 2023-05-15
    Public: No

    Description:
            Handles the Ability Cooldown UI.

    Parameter(s):
            _mode - One of the switch-cases [STRING]
            _params - Parameters from the event [ARRAY]

    Returns:
            Nothing [NIL]

    Example(s):
            ["refreshUI", _display] call vgm_c_fnc_displayAbilityCooldown;
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

        private _handlers = [];
        _handlers pushBack (["vgm_skills_active_slotted", [_display, {
            params ["", "_display"];

            ["refreshUI", _display] call SELF;
        }]] call para_g_fnc_event_subscribeLocal);

        _handlers pushBack (["vgm_skills_active_activated", [_display, {
            params ["_eventArgs", "_display"];
            _eventArgs params ["_slotName", "_skill"];

            ["renderCooldown", [_display, _slotName, _skill]] call SELF;
        }]] call para_g_fnc_event_subscribeLocal);

        _display setVariable ["vgm_skills_ui_eventHandlersIds", _handlers];

        ["refreshUI"] call SELF;
    };

    case "onUnload": {
        params ["_display"];
        {
            [_x] call para_g_fnc_event_unsubscribe;
        } forEach (_display getVariable "vgm_skills_ui_eventHandlersIds");
    };

    case "refreshUI": {
        params ["_display"];

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

    case "renderCooldown": {
        params ["_display", "_slotName", "_skill"];

        private _slot = vgm_c_skills_active_slots get _slotName;

        private _idcs = [
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNPRIMARY, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSPRIMARY],
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNULTIMATE, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSULTIMATE]
        ] select (_slotName == SLOT_ULTIMATE);

        (_idcs apply {_display displayCtrl _x}) params ["_ctrlCooldown", "_ctrlSeconds"];
        _ctrlSeconds ctrlSetFade 0;
        _ctrlSeconds ctrlCommit 5;

        _ctrlCooldown progressSetPosition 1;

        // start cooldown ticker
        #define TICK_TIME 0.5
        addMissionEventHandler ["EachFrame", {
            _thisArgs params ["_deltaT", "_ctrlCooldown", "_ctrlSeconds", "_remainingCooldown", "_totalCooldown"];

            _deltaT = _deltaT + diag_deltaTime;

            if (_deltaT >= TICK_TIME) then {
                _remainingCooldown = _remainingCooldown - _deltaT;

                // stop the loop, reset controls
                if (_remainingCooldown <= 0) exitWith {
                    _ctrlSeconds ctrlSetText "0 s";
                    _ctrlSeconds ctrlSetFade 1;
                    _ctrlSeconds ctrlCommit 3;
                    _ctrlCooldown progressSetPosition 0;

                    removeMissionEventHandler [_thisEvent, _thisEventHandler]
                };

                // progress the indicator
                _ctrlCooldown progressSetPosition (_remainingCooldown / _totalCooldown);
                _ctrlSeconds ctrlSetText format ["%1 s", ceil _remainingCooldown];

                _deltaT = _deltaT mod TICK_TIME;
                _thisArgs set [3, _remainingCooldown];
            };

            _thisArgs set [0, _deltaT];
        }, [0, _ctrlCooldown, _ctrlSeconds, _skill get "cooldown", _skill get "cooldown"]];
    };
};
