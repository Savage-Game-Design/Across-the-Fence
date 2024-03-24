#include "macros.inc"
/*
    File: fn_displayMenuBase.sqf
    Author: Savage Game Design
    Date: 2024-04-06
    Last Update: 2024-03-24
    Public: No

    Description:
        Implements functionalities for the "common" top bar in the gamemode displays.

    Parameter(s):
        _mode - Determines the part of this function to execute [STRING]
        _this - Parameters for the given _mode [ARRAY]

    Returns:
        NOTHING

    Example(s):
            ["onClickEquipment"] call vgm_c_fnc_displayMenuBase;
*/
#define SELF vgm_c_fnc_displayMenuBase

params ["_mode", "_this"];

// Helper function to get the "display" attribute of a header button
private _fnc_getButtonDisplay = {
    params ["_btn"];
    getText (missionConfigFile >> "VGM_DisplayMenuBase" >> "Controls" >> "HeaderBar" >> "Controls" >> ctrlClassName _btn >> "display")
};

switch _mode do {
    case "onLoadButton": {
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _iddOpen = ctrlIDD _display;
        private _class = _ctrl call _fnc_getButtonDisplay;
        private _idd = getNumber (missionConfigFile >> _class >> "idd");
        // Disable button that would open the current display
        if (_iddOpen == _idd) exitWith {
            _ctrl ctrlEnable false;
            _ctrl ctrlSetText format ["[ %1 ]", ctrlText _ctrl];
            _ctrl ctrlSetDisabledColor [VGM_UI_COLOR_TEXT];

            _display setVariable ["vgm_currentDisplay", _class];
        };

        switch ctrlClassName _ctrl do {
            case "Settings";
            case "Squad": {
                _ctrl ctrlEnable false;
                _ctrl ctrlSetTooltip "Work in Progress";
            };
        };
    };

    case "onClickEquipment": {
        params ["_ctrl"];
        ctrlParent _ctrl closeDisplay IDC_OK;

        private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
        if (isNil "_currentMission" || {_currentMission get "status" == "CREATED"}) exitWith {
            vgm_display_reopen = ctrlParent _ctrl getVariable "vgm_currentDisplay";
            [] spawn vgm_c_fnc_equipment_openArsenal;
        };

        player action ["Gear", objNull];
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
