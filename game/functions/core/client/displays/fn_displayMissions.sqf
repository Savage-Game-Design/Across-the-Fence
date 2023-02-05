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
        // private _result = ["showMessage", [_display, "Generate a Recon mission in targetBoxName?"]] call SELF;
        _result = true;
        if (_result) then {
            private _ctrlBriefing = _display ctrlCreate ["VGM_ctrlDisplayMissionsBriefing", VGM_IDC_DISPLAYMISSIONS_BRIEFING];
            [_ctrlBriefing, true] call vgm_c_fnc_toggle_controls_group_overlay;
        };
    };
    case "handleMessage": {
        _params params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _ctrlMessage = ctrlParentControlsGroup _ctrl;
        private _success = ctrlIDC _ctrl == VGM_IDC_DISPLAYMISSIONS_MESSAGE_CONFIRM;
        _ctrlMessage setVariable ["_result", _success];
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
    case "confirmMission": {
        _params params ["_ctrlBriefingConfirmMission"];
        private _display = ctrlParent _ctrlBriefingConfirmMission;
        _display closeDisplay IDC_OK;
    };
    case "discardMission": {
        _params params ["_ctrlBriefingDiscardMission"];
        private _display = ctrlParent _ctrlBriefingDiscardMission;
        private _ctrlBriefing = _display displayCtrl VGM_IDC_DISPLAYMISSIONS_BRIEFING;
        private _messageResult = ["showMessage", [_display, "Discard Operation generatedName?"]] call SELF;
        if (_messageResult) then {
            [_ctrlBriefing, false] call vgm_c_fnc_toggle_controls_group_overlay;
        } else {
        };

    };
    case "showMessage": {
        _params params ["_display", "_message"];
        private _ctrlMessage = _display ctrlCreate ["VGM_ctrlDisplayMissionsMessage", -1];
        [_ctrlMessage, true] call vgm_c_fnc_toggle_controls_group_overlay;
        private _ctrlMessageText = _ctrlMessage controlsGroupCtrl VGM_IDC_DISPLAYMISSIONS_MESSAGE_TEXT;
        _ctrlMessageText ctrlSetStructuredText parseText _message;
        waitUntil {!isNil {_ctrlMessage getVariable "_result"}};
        private _result = _ctrlMessage getVariable "_result";
        [_ctrlMessage, false] call vgm_c_fnc_toggle_controls_group_overlay;
        _result
    };

    default {
        false
    };
};
