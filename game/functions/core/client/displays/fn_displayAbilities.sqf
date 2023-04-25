/*
    File: fn_displayAbilities.sqf
    Author: Savage Game Design
    Date: 2023-01-31
    Public: No

    Description:
        UI script for the ability selection UI.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_displayAbilities
*/
#include "macros.inc"
#if __A3_DEBUG__
diag_log ["fn_displayAbilities", _this];
#endif
#define SELF vgm_c_fnc_displayAbilities
params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
        ["stdselect", _display displayCtrl VGM_IDC_DISPLAYABILITIES_STDTITLE] call SELF;
    };
    case "stdselect": {
        _params params ["_ctrlStdSelect"];
        private _display = ctrlParent _ctrlStdSelect;
        private _ctrlAvailable = _display displayCtrl VGM_IDC_DISPLAYABILITIES_AVAILABLE;
        private _available = []; // TODO: Get list of abilities
        _available resize 100;
        _available apply {
            private _name = "Hoof It"; // TODO: Get actual name
            private _icon = "\a3\3den\Data\Displays\Display3DENMsgBox\picture_ca.paa"; // TODO: Get actual icon
            /* private _icon = "#(rgb,8,8,3)color(1,0,0,0.5)"; */
            private _category = "Standard Rifleman Ability"; // TODO: Get actual category

            (ctAddRow _ctrlAvailable select 1) params [
                "", // Frame
                "_ctrlRowName",
                "_ctrlRowCategory",
                "", // Icon frame
                "_ctrlRowIcon",
                "_ctrlRowEquip"
            ];

            _ctrlRowName ctrlSetStructuredText parseText format ["<t size='1.25'>%1</t>", _name];
            _ctrlRowCategory ctrlSetText _category;
            _ctrlRowIcon ctrlSetText _icon;
            _ctrlRowEquip ctrlSetText "Equip"; // TODO: Localize
            _ctrlRowEquip ctrlAddEventHandler ["ButtonClick", {
                ["equip", _this] call SELF;
            }];
        };

    };
    case "ultselect": {
        _params params ["_ctrlStdSelect"];
    };
    case "equip": {
        _params params ["_ctrlRowEquip"];
    };
};
