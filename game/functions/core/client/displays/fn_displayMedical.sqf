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
params ["_mode", "_this"];
diag_log _this;
switch _mode do {
    case "onLoad":{
        params ["_display"];
    };
    case "setPartTitle":{
        params ["_ctrlTitle", "_cfg"];
        // Containing group contains the title, access the config hierarchy
        private _cfgHierarchy = configHierarchy _cfg;
        // Get the config of the group relative to the passed control
        // missionConfigFile >> Display >> Controls >> Part >> Controls >> Title
        private _cfgGroup = _cfgHierarchy select (count _cfgHierarchy - 3);
        private _title = getText (_cfgGroup >> "text");
        _ctrlTitle ctrlSetText _title;
    };
};
