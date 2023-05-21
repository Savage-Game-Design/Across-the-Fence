/*
    File: P:\SGD\Tour-of-Duty\game\functions\core\client\displays\fn_displayMedical.sqf
    Author: Savage Game Design
    Date: 2023-35-18
    Last Update: 2023-35-18
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
#include "macros.inc"
diag_log _this;
params ["_mode", "_this"];
switch _mode do {
    case "onLoad":{
        params ["_display"];
    };
    case "selectPart": {
        params ["_ctrlPartIcon"];
        private _display = ctrlParent _ctrlPartIcon;
        // Set the title for the treatment options
        private _title = ["Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"] select (ctrlIDC _ctrlPartIcon - VGM_IDC_DISPLAYMEDICAL_HEAD);
        private _ctrlTitle = _display displayCtrl VGM_IDC_DISPLAYMEDICAL_TREATMENT_TITLE;
        _ctrlTitle ctrlSetText _title;
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
        if (ctrlShown _ctrlTreatment && !(getMousePosition inArea _cArea)) then {
            _ctrlTreatment ctrlShow false;
        };
    };
};
