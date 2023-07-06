#include "script_component.inc"
/*
    File: fn_medical_openMedicalMenu.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-07-06
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [] call vgm_c_fnc_medical_openMedicalMenu;
 */

private _target = cursorTarget;
if (!(_target isKindOf "CAManBase") || {player distance _target > 15}) then {
    _target = player;
};

private _activeStatusEffects = keys vgm_c_statusEffect_map select {[_target, _x] call vgm_c_fnc_statusEffect_get};;

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
_display setVariable ["vgm_medical_patient", _target];

private _w = safeZoneW/3.5;
private _h = safeZoneH/2;

private _ctrlContainer = _display ctrlCreate ["RscControlsGroupNoScrollBars", -1];
_ctrlContainer ctrlSetPosition [
    safeZoneX + safeZoneW/2 - _w/2, safeZoneY + safeZoneH/2 - _h/2,
    _w, _h
];
_ctrlContainer ctrlCommit 0;
_display setVariable ["vgm_container", _ctrlContainer];

ctrlPosition _ctrlContainer params ["_x", "_y", "_w", "_h"];

private _ctrlBg = _display ctrlCreate ["RscText", -1, _ctrlContainer];
_ctrlBg ctrlSetBackgroundColor [0,0,0,0.4];
_ctrlBg ctrlSetPosition [0, 0, _w, _h];
_ctrlBg ctrlCommit 0;

_h = _h/count BODY_PARTS_ARR;

private _ctrlHeader = _display ctrlCreate ["RscText", -1];
_ctrlHeader ctrlSetText format ["%1 | Status effects: %2", name _target, _activeStatusEffects];
_ctrlHeader ctrlSetBackgroundColor [0,0,0,1];
_ctrlHeader ctrlSetPosition [_x, _y - _h, _w, _h];
_ctrlHeader ctrlCommit 0;

_w = _w/4;

_display setVariable ["vgm_wh", [_w, _h]];

vgm_c_medicalMenu_fnc_render = {
    params ["_display", "_target"];
    private _ctrlContainer = _display getVariable "vgm_container";
    (_display getVariable "vgm_wh") params ["_w", "_h"];

    {ctrlDelete _x} forEach (_display getVariable ["vgm_medical_controls", []]);
    private _ctrls = [];
    _display setVariable ["vgm_medical_controls", _ctrls];

    {
        private _bodyPart = _x;
        private _bodyPartVar = format ["vgm_g_medical_wound$%1", _bodyPart];

        private _ctrlLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        _ctrlLabel ctrlSetText _x;
        _ctrlLabel ctrlSetPosition [_w*0, _h * _forEachIndex, _w, _h];
        _ctrlLabel ctrlCommit 0;

        private _ctrlDmg = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        _ctrlDmg ctrlSetText str (_target getVariable [_bodyPartVar, -1]);
        _ctrlDmg ctrlSetPosition [_w*1, _h * _forEachIndex, _w, _h];
        _ctrlDmg ctrlCommit 0;

        private _ctrlBtnFak = _display ctrlCreate ["RscButton", -1, _ctrlContainer];
        _ctrlBtnFak ctrlSetText "Apply FAK";
        _ctrlBtnFak ctrlSetPosition [_w*2, _h * _forEachIndex, _w, _h];
        _ctrlBtnFak ctrlCommit 0;

        _ctrlBtnFak setVariable ["vgm_medical_bodyPart", _bodyPart];
        _ctrlBtnFak ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrlBtn"];
            private _display = ctrlParent _ctrlBtn;
            private _target = _display getVariable "vgm_medical_patient";
            private _bodyPart = _ctrlBtn getVariable "vgm_medical_bodyPart";
            [objNull, _target, _bodyPart] call vgm_c_fnc_medical_itemApplyFAK;

            [_display, _target] spawn {
                sleep 1;
                _this call (missionNamespace getVariable "vgm_c_medicalMenu_fnc_render");
            };
        }];

        private _ctrlBtnMedikit = _display ctrlCreate ["RscButton", -1, _ctrlContainer];
        _ctrlBtnMedikit ctrlSetText "Apply Medikit";
        _ctrlBtnMedikit ctrlSetPosition [_w*3, _h * _forEachIndex, _w, _h];
        _ctrlBtnMedikit ctrlCommit 0;

        _ctrlBtnMedikit setVariable ["vgm_medical_bodyPart", _bodyPart];
        _ctrlBtnMedikit ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrlBtn"];
            private _display = ctrlParent _ctrlBtn;
            private _target = _display getVariable "vgm_medical_patient";
            private _bodyPart = _ctrlBtn getVariable "vgm_medical_bodyPart";
            [objNull, _target, _bodyPart] call vgm_c_fnc_medical_itemApplyMedikit;

            [_display, _target] spawn {
                sleep 1;
                _this call (missionNamespace getVariable "vgm_c_medicalMenu_fnc_render");
            };
        }];

        _ctrls append [_ctrlLabel, _ctrlDmg, _ctrlBtnFak, _ctrlBtnMedikit];
    } forEach BODY_PARTS_ARR;
};

[_display, _target] call vgm_c_medicalMenu_fnc_render;
