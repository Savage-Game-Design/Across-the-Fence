#include "script_component.inc"
/*
    File: fn_medical_itemApplyMedikit.sqf
    Author: Savage Game Design
    Date: 2023-06-30
    Last Update: 2023-08-20
    Public: No

    Description:
        Apply Medikit to the patient.

    Parameter(s):
        _healer - Unit doing the healing [OBJECT]
        _patient - Unit being healed [OBJECT]
        _bodyPart - Body part that is being healed [STRING]

    Returns:
        Nothing

    Example(s):
        [player, cursorObject, "legs"] call vgm_c_fnc_medical_itemApplyMedikit
 */

params ["_healer", "_patient", "_bodyPart"];

format ["Applying Medikit: %1 | %2 | %3", _healer, _patient, _bodyPart] call vgm_g_fnc_logInfo;

[_healer, _patient, _bodyPart, createHashMapFromArray [
    ["type", HEAL_MEDIKIT],
    ["time", 5],
    ["displayName", localize "STR_VGM_MEDICAL_UI_APPLY_MEDIKIT"]
]] call vgm_c_fnc_medical_itemApply;

