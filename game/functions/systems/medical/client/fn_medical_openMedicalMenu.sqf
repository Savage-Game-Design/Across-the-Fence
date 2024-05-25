#include "script_component.inc"
/*
    File: fn_medical_openMedicalMenu.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-09-03
    Public: No

    Description:
        Open medical menu on a target unit.

    Parameter(s):
        _unit - The target unit [OBJECT, defaults to cursorTarget]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_openMedicalMenu;
 */

private _target = param [0, cursorTarget];
if (!(_target isKindOf "CAManBase") || {player distance _target > 15}) then {
    _target = player;
};

missionNamespace setVariable ["vgm_c_medical_menuTarget", _target];
createDialog "VGM_DisplayMedical";
