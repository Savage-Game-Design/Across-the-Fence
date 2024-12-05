#include "..\..\..\..\functions\systems\medical\client\script_component.inc"
#include "macros.inc"
/*
    File: fn_displayMedical.sqf
    Author: Savage Game Design
    Date: 2023-05-18
    Last Update: 2024-12-05
    Public: No

    Description:
        Adds functionality to the Medical UI.

    Parameter(s):
        _mode - Determines the part of this function to execute [STRING]
        _this - Parameters for the given _mode [ARRAY]

    Returns:
        nil [NOTHING]

    Example(s):
        ["onLoad", [findDisplay 28000]] call vgm_c_fnc_displayMedical;
*/

#define SELF vgm_c_fnc_displayMedical
#define HEALER player
#define MENU_TARGET (missionNamespace getVariable ["vgm_c_medical_menuTarget", player])

#define COLOR_NONE 1,1,1
#define COLOR_MINOR 0.89,0.8,0
#define COLOR_MAJOR 0.9,0.1,0
#define COLOR_SEVERE 0.58,0,0
#define COLOR_ARR [[COLOR_NONE], [COLOR_MINOR], [COLOR_MAJOR], [COLOR_SEVERE]]
// 1 - HUD_ALPHA + HUD_ALPHA_WOUND
#define HUD_ALPHA 0.8
#define HUD_ALPHA_WOUND 0.4

#if __A3_DEBUG__
    diag_log ["fn_displayMedical", _this];
#endif

params ["_mode", "_this"];

switch _mode do {
    case "onLoad": {
        params ["_display"];

        uiNamespace setVariable ["VGM_DisplayMedical", _display];

        private _ctrlTreatment = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT;
        _ctrlTreatment ctrlShow false;

        private _ctrlTitlePatient = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_PATIENT_TITLE;
        _ctrlTitlePatient ctrlSetText name MENU_TARGET;

        ["refreshUI", _display] call SELF;
        _display spawn {
            waitUntil {
                uiSleep 1;
                isNil {["refreshUI", _this] call SELF};
                isNull _this // return
            };
        };

        if (MENU_TARGET == player) then {
            {
                _x ctrlSetFade 1;
                _x ctrlCommit 1;
            } forEach allControls (uiNamespace getVariable ["VGM_RscMedicalStatus", displayNull]);
        };
    };

    case "onUnload": {
        params ["_display"];

        if (MENU_TARGET == player) then {
            {
                _x ctrlSetFade 0;
                _x ctrlCommit 1;
            } forEach allControls (uiNamespace getVariable ["VGM_RscMedicalStatus", displayNull]);
        };
    };

    // onLoad for HUD variant of the medical UI
    case "onLoadHud": {
        params ["_display"];

        uiNamespace setVariable ["VGM_RscMedicalStatus", _display];

        private _refreshHandlersIds = [];
        _display setVariable ["vgm_medical_refreshHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, [_display, {
                params ["", "_display"];
                ["refreshUI", [_display, player, HUD_ALPHA]] call SELF;
            }]] call para_g_fnc_event_subscribeLocal;

            _refreshHandlersIds pushBack _ehId;
        } forEach [
            "vgm_medical_woundAdded",
            "vgm_medical_woundRemoved",
            "vgm_player_respawn",
            "para_keybindingMenu_unload"
        ];

        ["refreshUI", [_display, player, HUD_ALPHA]] call SELF;
    };

    // onUnload for HUD variant of the medical UI
    case "onUnloadHud": {
        params ["_display"];

        {[_x] call para_g_fnc_event_unsubscribe} forEach (_display getVariable "vgm_medical_refreshHandlerIds");
    };

    case "refreshUI": {
        params ["_display", "_target", "_alphaModifier"];

        private _ctrlControlsHint = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_CONTROLSHINT;
        if (!isNull _ctrlControlsHint) then {
            _ctrlControlsHint ctrlSetText format [
                localize "STR_VGM_MEDICAL_UI_HEALTH_STATUS_KEYBIND",
                [
                    ["OpenMedicalMenuSelf"] call para_c_fnc_keyhandler_getKeyBind,
                    true
                ] call para_c_fnc_keyhandler_stringifyKeybind
            ];
        };

        ["colorBodyParts", _this] call SELF;
        ["updateDebuffsList", _this] call SELF;
    };

    // handle selection of body part for treatment
    case "selectPart": {
        if (lifeState player == "INCAPACITATED") exitWith {};

        params ["_ctrlPartIcon"];
        private _display = ctrlParent _ctrlPartIcon;
        private _visualPart = ["head", "torso", "left_arm", "right_arm", "left_leg", "right_leg"] select (ctrlIDC _ctrlPartIcon - VGM_IDC_DISPLAYMEDICAL_HEAD);

        private _partData = createHashMapFromArray [
            ["head", ["STR_VGM_MEDICAL_UI_BODY_PART_HEAD", BODY_PART_HEAD]],
            ["torso", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_TORSO]],
            ["left_arm", ["STR_VGM_MEDICAL_UI_BODY_PART_ARMS", BODY_PART_ARMS]],
            ["right_arm", ["STR_VGM_MEDICAL_UI_BODY_PART_ARMS", BODY_PART_ARMS]],
            ["left_leg", ["STR_VGM_MEDICAL_UI_BODY_PART_LEGS", BODY_PART_LEGS]],
            ["right_leg", ["STR_VGM_MEDICAL_UI_BODY_PART_LEGS", BODY_PART_LEGS]]
        ] get _visualPart;

        _partData params ["_title", "_bodyPart"];

        private _injuries = [MENU_TARGET, _bodyPart] call vgm_c_fnc_medical_getWound;

        private _ctrlTitle = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT_TITLE;
        _ctrlTitle ctrlSetText localize _title;

        private _ctrlInjuriesCount = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT_INJURIESCOUNT;
        _ctrlInjuriesCount ctrlSetText format [localize "STR_VGM_MEDICAL_UI_INJURIES", _injuries];

        // Add treatment options
        private _ctrlOptions = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT_OPTIONS;
        ctClear _ctrlOptions;
        _ctrlOptions ctrlEnable (_injuries > 0);

        private _healerItemCount = uniqueUnitItems [HEALER, 0, 2, 2, 2, false];
        {
            _x params ["_treatment", "_itemCfg", "_function", ["_condition", {true}]];

            private _optionItems = vgm_medical_healItems get _treatment;
            private _requiredItemCount = 0;
            {_requiredItemCount = _requiredItemCount + (_healerItemCount getOrDefault [_x, 0])} forEach _optionItems;

            (ctAddRow _ctrlOptions select 1) params ["_ctrlOptionIcon", "_ctrlOptionName", "_ctrlOptionButton"];
            _ctrlOptionIcon ctrlSetText getText (_itemCfg >> "picture");
            _ctrlOptionName ctrlSetStructuredText parseText format [
                localize (["STR_VGM_MEDICAL_UI_OWNED_NO_TRAINING", "STR_VGM_MEDICAL_UI_OWNED"] select (call _condition)),
                getText (_itemCfg >> "displayName"),
                _requiredItemCount
            ];
            _ctrlOptionButton ctrlEnable ((_requiredItemCount > 0) && _condition);

            // setup on click action
            _ctrlOptionButton setVariable ["vgm_params", [HEALER, MENU_TARGET, _bodyPart]];
            _ctrlOptionButton setVariable ["vgm_function", _function];
            _ctrlOptionButton ctrlAddEventHandler ["ButtonClick", {
                params ["_ctrlButton"];
                (_ctrlButton getVariable "vgm_params") call (_ctrlButton getVariable "vgm_function");
                closeDialog 0;
            }];
        } forEach [
            [HEAL_FAK, configFile >> "CfgWeapons" >> "vn_helper_item_firstaidkit", vgm_c_fnc_medical_itemApplyFAK],
            [HEAL_MEDIKIT, configFile >> "CfgWeapons" >> "vn_helper_item_medikit", vgm_c_fnc_medical_itemApplyMedikit, {HEALER getUnitTrait "Medic"}]
        ];

        // Activate the treatment options
        private _ctrlTreatment = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT;
        _ctrlTreatment ctrlShow true;
        ctrlPosition _ctrlTreatment params ["","","_cw", "_ch"];
        getMousePosition params ["_xPos", "_yPos"];
        // Clamp position to not go offscreen
        _ctrlTreatment ctrlSetPosition [
            (_xPos+pixelW) min (safeZoneX + safeZoneW - _cw),
            (_yPos+pixelH) min (safeZoneY + safeZoneH - _ch)
        ];
        _ctrlTreatment ctrlCommit 0;
        ctrlSetFocus _ctrlTreatment;
    };

    // handle colorization of body parts
    case "colorBodyParts": {
        params ["_display", ["_target", MENU_TARGET], ["_alphaModifier", 0]];

        {
            _x params ["_idc", "_bodyPart"];
            private _ctrl = _display displayCtrl _idc;

            private _wound = [_target, _bodyPart] call vgm_c_fnc_medical_getWound;

            private _color = COLOR_ARR select _wound;
            _ctrl ctrlSetTextColor (_color + [1 - _alphaModifier + (_wound min HUD_ALPHA_WOUND)]);

            private _levelText = localize format ["STR_VGM_MEDICAL_UI_TRAUMA_%1", _wound];
            _ctrl ctrlSetTooltip format [localize "STR_VGM_MEDICAL_UI_INJURIES", _levelText];
        } forEach [
            [VGM_IDC_DISPLAYMEDICAL_HEAD, BODY_PART_HEAD],
            [VGM_IDC_DISPLAYMEDICAL_ARMLEFT, BODY_PART_ARMS],
            [VGM_IDC_DISPLAYMEDICAL_ARMRIGHT, BODY_PART_ARMS],
            [VGM_IDC_DISPLAYMEDICAL_TORSO, BODY_PART_TORSO],
            [VGM_IDC_DISPLAYMEDICAL_LEGLEFT, BODY_PART_LEGS],
            [VGM_IDC_DISPLAYMEDICAL_LEGRIGHT, BODY_PART_LEGS]
        ];
    };

    case "updateDebuffsList": {
        params ["_display", ["_target", MENU_TARGET]];

        private _ctrlModifierList = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_MODIFIERLIST;
        if (isNull _ctrlModifierList) exitWith {};
        ctClear _ctrlModifierList;

        private _fnc_addRow = {
            params ["_title", "_description", "_icon"];

            (ctAddRow _ctrlModifierList select 1) params ["", "_ctrlIcon", "_ctrlDescription"];
            _ctrlIcon ctrlSetText _icon;
            private _text = format ["%1<br/>%2", _title, _description];
            _ctrlDescription ctrlSetStructuredText parseText _text;
        };

        if ([_target, "bleeding"] call vgm_c_fnc_statusEffect_get) then {
            [
                localize "STR_VGM_MEDICAL_UI_DEBUFF_BLEEDING",
                "",
                format ["#(rgb,1,1,1)color(%1,%2,%3,1)", COLOR_SEVERE]
            ] call _fnc_addRow;
        };

        {
            private _bodyPart = _x;
            private _bodyPartInjuryEffects = vgm_medical_injuryEffects get _bodyPart;

            private _currentWoundLevel = [_target, _bodyPart] call vgm_c_fnc_medical_getWound;
            private _coefficients = createHashMap;
            private _statusEffects = createHashMap;

            for "_woundLevel" from WOUND_NONE to _currentWoundLeveL do {
                private _injuryEffects = _bodyPartInjuryEffects get _woundLevel;

                // insert will overwrite with latest value of the debuff
                _coefficients insert (_injuryEffects get "coefficient");
                _statusEffects insert (_injuryEffects get "statusEffect");
            };


            private _fnc_addRow = {
                params ["_title", "_description", "_icon", "_iconColor"];

                (ctAddRow _ctrlModifierList select 1) params ["", "_ctrlIcon", "_ctrlDescription"];
                _ctrlIcon ctrlSetText _icon;
                _ctrlIcon ctrlSetTextColor _iconColor + [1];
                private _text = format ["%1<br/>%2", _title, _description];
                _ctrlDescription ctrlSetStructuredText parseText _text;
            };

            private _iconFallback = "#(rgb,1,1,1)color(1,1,1,1)";
            private _iconColor = COLOR_ARR select _currentWoundLevel;
            private _level = localize format ["STR_VGM_MEDICAL_UI_TRAUMA_%1", _currentWoundLeveL];
            private _bodyPart = localize format ["STR_VGM_MEDICAL_UI_BODY_PART_%1", _bodyPart];
            private _title = format ["%1 %2 Trauma", _level, _bodyPart];

            // render debuff rows
            private _effects = [];
            {
                if (!_y) then {continue};
                private _statusDescription = localize format ["STR_VGM_MEDICAL_UI_DEBUFF_%1", _x];
                private _statusIcon = vgm_medical_injuryEffectsIcons getOrDefault [_x, _iconFallback];
                [_title, _statusDescription, _statusIcon, _iconColor] call _fnc_addRow;
            } forEach _statusEffects;

            {
                if (_y == 0) then {continue};
                private _coefDescription = localize format ["STR_VGM_MEDICAL_UI_DEBUFF_%1", _x];
                _coefDescription = format ["%2%3 %1", _coefDescription, abs _y * 100, "%"];
                private _coefIcon = vgm_medical_injuryEffectsIcons getOrDefault [_x, _iconFallback];
                [_title, _coefDescription, _coefIcon, _iconColor] call _fnc_addRow;
            } forEach _coefficients;

        } forEach BODY_PARTS_ARR;
    };

    case "mouseDown": {
        params ["_display", "_button", "_xPos", "_yPos"];
        private _ctrlTreatment = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT;
        // Get area of treatment options control
        ctrlPosition _ctrlTreatment params ["_cX", "_cY", "_cW", "_cH"];
        _cW = _cW/2;
        _cH = _cH/2;
        _cX = _cX + _cW;
        _cY = _cY + _cH;
        private _cArea = [[_cX,_cY], _cW, _cH, 0, true];
        getMousePosition params ["_mouseX", "_mouseY"];
        // Hide treatment options when clicked outside of treatment options group
        // (if part is selected it will be shown again, because ButtonClick EH fires after this one)
        if (ctrlShown _ctrlTreatment && !(getMousePosition inArea _cArea)) then {
            _ctrlTreatment ctrlShow false;
        };
    };
    case "selectTreatment": {
        params ["_ctrlOptionButton"];
        private _display = ctrlParent _ctrlOptionButton;
        // Get the selected treatment option
        private _option = _ctrlOptionButton getVariable "option";
        // Hide the treatment options
        private _ctrlTreatment = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT;
        _ctrlTreatment ctrlShow false;
    };
};
