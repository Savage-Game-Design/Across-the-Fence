#include "script_component.inc"
/*
    File: fn_medical_openMedicalMenu.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2025-02-01
    Public: No

    Description:
        Open medical menu on a target unit.

    Parameter(s):
        _target - The target unit [OBJECT, defaults to cursorTarget]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_openMedicalMenu;
 */

params [["_target", cursorTarget]];

private _currentMedicalMenu = uiNamespace getVariable ["VGM_DisplayMedical", displayNull];
_currentMedicalMenu closeDisplay 2;

if (
    !isPlayer _target
    || !(_target isKindOf "CAManBase")
    || {player distance _target > 5}
) then {
    _target = player;
};

missionNamespace setVariable ["vgm_c_medical_menuTarget", _target];
createDialog "VGM_DisplayMedical";
