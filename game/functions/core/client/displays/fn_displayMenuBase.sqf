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
    case "onLoad":{
        params ["_ctrlHeaderBar"];
        private _display = ctrlParent _ctrlHeaderBar;
        // Disable button that would open the current display
        private _buttons = allControls _ctrlHeaderBar;
        private _iddOpen = ctrlIDD _display;
        private _ctrlCurrent = _buttons deleteAt (_buttons findIf {
            private _class = _x call _fnc_getButtonDisplay;
            private _idd = getNumber (missionConfigFile >> _class >> "idd");
            _iddOpen == _idd
        });
        _ctrlCurrent ctrlEnable false;


        // Add functinoality to all other buttons
        _buttons apply {
            _x ctrlAddEventHandler ["ButtonClick", {
                ["switchMenu", _this] call SELF;
            }];
        };
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
