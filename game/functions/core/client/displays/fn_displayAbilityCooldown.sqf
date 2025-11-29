#include "macros.inc"
/*
    File: fn_displayAbilityCooldown.sqf
    Author: Savage Game Design
    Date: 2023-06-14
    Last Update: 2025-11-29
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
#define SLOT_ABILITY_1 "ability1"
#define SLOT_ABILITY_2 "ability2"

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
            [VGM_IDC_RSCABILITYCOOLDOWN_ICONPRIMARY, SLOT_ABILITY_1],
            [VGM_IDC_RSCABILITYCOOLDOWN_ICONULTIMATE, SLOT_ABILITY_2]
        ];
    };

    case "renderCooldown": {
        params ["_display", "_slotName", "_skill"];

        private _slot = vgm_c_skills_active_slots get _slotName;

        private _idcs = [
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNPRIMARY, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSPRIMARY, VGM_IDC_RSCABILITYCOOLDOWN_DURATIONPRIMARY],
            [VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNULTIMATE, VGM_IDC_RSCABILITYCOOLDOWN_SECONDSULTIMATE, VGM_IDC_RSCABILITYCOOLDOWN_DURATIONULTIMATE]
        ] select (_slotName == SLOT_ABILITY_2);

        (_idcs apply {_display displayCtrl _x}) params ["_ctrlCooldown", "_ctrlSeconds", "_ctrlDuration"];
        _ctrlSeconds ctrlSetFade 0;
        _ctrlSeconds ctrlCommit 5;

        _ctrlCooldown progressSetPosition 0;
        _ctrlDuration progressSetPosition 1;

        // start cooldown ticker
        #define TICK_TIME 0.5
        addMissionEventHandler ["EachFrame", {
            _thisArgs params ["_deltaT", "_ctrlCooldown", "_ctrlSeconds", "_ctrlDuration", "_slot"];

            _deltaT = _deltaT + diag_deltaTime;

            if (_deltaT >= TICK_TIME) then {
                _deltaT = _deltaT mod TICK_TIME;

                private _remainingCooldown = (_slot get "cooldownUntil") - time;
                private _remainingDuration = (_slot get "activeUntil") - time;

                if (_remainingDuration > 0) exitWith {
                    _ctrlDuration progressSetPosition ((_remainingDuration / (_slot get "activeTime")) min 1 max 0);
                    _ctrlSeconds ctrlSetText format ["%1 s", ceil _remainingDuration];
                };

                // stop the loop, reset controls
                if (_remainingCooldown <= 0) exitWith {
                    _ctrlSeconds ctrlSetText "0 s";
                    _ctrlSeconds ctrlSetFade 1;
                    _ctrlSeconds ctrlCommit 3;
                    _ctrlCooldown progressSetPosition 0;
                    _ctrlDuration progressSetPosition 0;

                    removeMissionEventHandler [_thisEvent, _thisEventHandler]
                };

                _ctrlDuration progressSetPosition 0;
                _ctrlCooldown progressSetPosition ((1 - (_remainingCooldown / (_slot get "cooldownTime"))) min 1 max 0);
                _ctrlSeconds ctrlSetText format ["%1 s", ceil _remainingCooldown];
            };

            _thisArgs set [0, _deltaT];
        }, [0, _ctrlCooldown, _ctrlSeconds, _ctrlDuration, _slot]];
    };
};
