/*
    File: fn_displayMissions.sqf
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
*/
#include "macros.inc"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
#define SELF vgm_c_fnc_displayMissions
#ifdef __A3_DEBUG__
diag_log _this;
#endif
params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
        private _ctrlTargets = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_TARGET;
        _ctrlTargets lbSetCurSel 0;
        _display setVariable ["_selectedDifficulty", 0];
    };
    case "selectDifficulty": {
        _params params ["_ctrlImage"];
        private _display = ctrlParent _ctrlImage;
        private _selectedDifficulty = [
            VGM_IDC_DISPLAYMISSIONS_RECON,
            VGM_IDC_DISPLAYMISSIONS_STANDARD,
            VGM_IDC_DISPLAYMISSIONS_ELITE
        ] findIf {ctrlIDC ctrlParentControlsGroup _ctrlImage == _x};
        _display setVariable ["_selectedDifficulty", _selectedDifficulty];
    };
    case "initTargets":{
        _params params ["_ctrlTargets"];
        for "_i" from 0 to 10 do {
            _ctrlTargets lbAdd format ["Test %1", _i];
        };
    };
    case "generate": {
        _params params ["_ctrlGenerate"];
        private _display = ctrlParent _ctrlGenerate;
        private _ctrlMessage = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_MESSAGE;
        // Block all other controls but keep track of current state
        private _enabledControls = allControls _display select {
            ctrlEnabled _x && ctrlParentControlsGroup _x != _ctrlMessage
        };
        _display setVariable ["_enabledControls", _enabledControls];
        _enabledControls apply {_x ctrlEnable false};
        _ctrlMessage ctrlShow true;
        _ctrlMessage ctrlEnable true;
        ctrlSetFocus _ctrlMessage;
        diag_log [_display getVariable "_selectedDifficulty"];
    };
    case "handleMessage": {
        _params params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _ctrlMessage = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_MESSAGE;
        private _success = ctrlIDC _ctrl == VGM_IDC_DISPLAYMISSIONS_MESSAGE_CONFIRM;
        private _controlsToEnable = _display getVariable ["_enabledControls", []];
        _controlsToEnable apply {_x ctrlEnable true};
        _ctrlMessage ctrlShow false;
        _ctrlMessage ctrlEnable false;
    };
    case "loadProperties": {
        _params params ["_ctrlMissionProperties"];
        for "_i" from 0 to 10 do {
            (ctAddRow _ctrlMissionProperties select 1) params ["", "_ctrlProperty", "_ctrlReveal"];
            _ctrlProperty ctrlSetText format ["Test %1", _i];
            _ctrlReveal ctrlSetText format ["Reveal [%1 Intel]", 100];
            private _ehid = _ctrlReveal ctrlAddEventHandler ["ButtonClick", {
                ["revealProperty", _this] call SELF;
            }];
            _ctrlReveal setVariable ["_ehidReveal", _ehid];
        };
    };
    case "revealProperty": {
        _params params ["_ctrlReveal"];
        private _display = ctrlParent _ctrlReveal;
        private _ctrlMissionProperties = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_BRIEFING_MISSIONPROPERTIES;
        private _selectedIndex = ctCurSel _ctrlMissionProperties;
        _ctrlReveal ctrlSetText format ["Remove [%1 Intel]", 100];
        _ctrlReveal ctrlRemoveEventHandler ["ButtonClick", (_ctrlReveal getVariable ["_ehidReveal", -1])];
        _ctrlReveal ctrlAddEventHandler ["ButtonClick", {
            ["removeProperty", _this] spawn SELF;
        }];
    };
    case "removeProperty": {
        _params params ["_ctrlReveal"];
        private _display = ctrlParent _ctrlReveal;
        private _ctrlMissionProperties = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_BRIEFING_MISSIONPROPERTIES;
        private _selectedIndex = ctCurSel _ctrlMissionProperties;
        _ctrlMissionProperties ctRemoveRows [_selectedIndex];
    };
    default {
        false
    };
};
