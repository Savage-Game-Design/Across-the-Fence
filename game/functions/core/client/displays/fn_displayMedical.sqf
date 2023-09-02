#include "..\..\..\..\functions\systems\medical\client\script_component.inc"
#include "macros.inc"
/*
    File: fn_displayMedical.sqf
    Author: Savage Game Design
    Date: 2023-05-18
    Last Update: 2023-09-02
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
#define MENU_TARGET player

#if __A3_DEBUG__
    diag_log ["fn_displayMedical", _this];
#endif

params ["_mode", "_this"];

switch _mode do {
    case "onLoad":{
        params ["_display"];

        ["colorParts", _display] call SELF;

        private _ctrlModifierList = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_MODIFIERLIST;
        private _modifiers = [];
        _modifiers resize 20;
        _modifiers apply {
            private _part = "Head";
            private _type = "Trauma";
            private _level = "Severe";
            private _effect = "Occasional Blurred Vision";
            private _icon = "#(rgb,1,1,1)color(1,0,0,1)";

            (ctAddRow _ctrlModifierList select 1) params ["", "_ctrlIcon", "_ctrlDescription"];
            _ctrlIcon ctrlSetText _icon;
            _ctrlDescription ctrlSetStructuredText parseText format ["%1 %2 %3<br/>%4", _level, _part, _type, _effect];
        };
    };
    // handle selection of body part for treatment
    case "selectPart": {
        params ["_ctrlPartIcon"];
        private _display = ctrlParent _ctrlPartIcon;
        private _visualPart = ["head", "torso", "left_arm", "right_arm", "left_leg", "right_leg"] select (ctrlIDC _ctrlPartIcon - VGM_IDC_DISPLAYMEDICAL_HEAD);

        private _partData = createHashMapFromArray [
            ["head", ["STR_VGM_MEDICAL_UI_BODY_PART_HEAD", BODY_PART_HEAD]],
            ["torso", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_TORSO]],
            ["left_arm", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_ARMS]],
            ["right_arm", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_ARMS]],
            ["left_leg", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_LEGS]],
            ["right_leg", ["STR_VGM_MEDICAL_UI_BODY_PART_TORSO", BODY_PART_LEGS]]
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
        private _options = ["fak", "medkit"];
        _options apply {
            private _name = _x;
            private _count = 99;
            (ctAddRow _ctrlOptions select 1) params ["_ctrlOptionIcon", "_ctrlOptionName", "_ctrlOptionButton"];
            _ctrlOptionIcon ctrlSetText "\vn\editorpreviews_f_vietnam\weapons\preview_vn_b_item_firstaidkit.jpg";
            _ctrlOptionName ctrlSetStructuredText parseText format ["%1<br/>Owned: %2", _name, _count];
            _ctrlOptionButton setVariable ["option", _x];
        };

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
    case "colorParts": {
        params ["_display"];

        {
            _x params ["_idc", "_bodyPart"];
            private _ctrl = _display displayCtrl _idc;

            private _color = [
                [1,1,1,1],
                [1,1,0,1],
                [1,0.5,0,1],
                [1,0,0,1]
            ] select ([MENU_TARGET, _bodyPart] call vgm_c_fnc_medical_getWound);

            _ctrl ctrlSetTextColor _color;
        } forEach [
            [VGM_IDC_DISPLAYMEDICAL_HEAD, BODY_PART_HEAD],
            [VGM_IDC_DISPLAYMEDICAL_ARMLEFT, BODY_PART_ARMS],
            [VGM_IDC_DISPLAYMEDICAL_ARMRIGHT, BODY_PART_ARMS],
            [VGM_IDC_DISPLAYMEDICAL_TORSO, BODY_PART_TORSO],
            [VGM_IDC_DISPLAYMEDICAL_LEGLEFT, BODY_PART_LEGS],
            [VGM_IDC_DISPLAYMEDICAL_LEGRIGHT, BODY_PART_LEGS]
        ];
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
