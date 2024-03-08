/*
    File: P:\SGD\Across-the-Fence\game\functions\core\client\displays\fn_displayMenuBase.sqf
    Author: Savage Game Design
    Date: 2024-04-06
    Last Update: 2024-04-06
    Public: No

    Description:
            __DESCRIPTION__

    Parameter(s):
            _var - __DESC__ [TYPE]

    Returns:
            __DESC__ [TYPE]

    Example(s):
            [] call vgm_c_fnc_;
*/
#include "macros.inc"
#define SELF vgm_c_fnc_displayMenuBase
params ["_mode", "_this"];

private _fnc_getButtonDisplay = {
    // Helper function to get the "display" attribute of a header button
    params ["_btn"];
    getText (missionConfigFile >> "VGM_DisplayMenuBase" >> "Controls" >> "HeaderBar" >> "Controls" >> ctrlClassName _btn >> "display")
};

switch _mode do {
    case "onLoadButton": {
        params ["_ctrl"];
        // Disable button that would open the current display
        private _display = ctrlParent _ctrl;
        private _iddOpen = ctrlIDD _display;
        private _class = _ctrl call _fnc_getButtonDisplay;
        private _idd = getNumber (missionConfigFile >> _class >> "idd");
        if (_iddOpen == _idd) exitWith {
            _ctrl ctrlEnable false;
            _ctrl ctrlSetText format ["[ %1 ]", ctrlText _ctrl];
            _ctrl ctrlSetDisabledColor [VGM_UI_COLOR_TEXT];
        };

        switch ctrlClassName _ctrl do {
            case "Settings";
            case "Squad": {
                _ctrl ctrlEnable false;
            };
        };
    };
    case "onClickEquipment": {
        params ["_ctrl"];
        ctrlParent _ctrl closeDisplay IDC_OK;
        [] spawn BIS_fnc_arsenal;
    };
    case "onClickAbilities";
    case "onClickSkillTree": {
        params ["_ctrl"];
        ["switchMenu", [_ctrl]] call SELF;
    };
    case "switchMenu": {
        // Close current menu and open newly selected one
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        _display closeDisplay IDC_OK;
        private _class = _ctrl call _fnc_getButtonDisplay;
        createDialog _class;
    };
};
