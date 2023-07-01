/*
    File: fn_medical_itemApplyFAK.sqf
    Author: Savage Game Design
    Date: 2023-06-30
    Last Update: 2023-06-30
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player, cursorObject] call vgm_c_fnc_medical_itemApplyFAK
 */

params ["_healer", "_patient", "_bodyPart"];

format ["Applying FAK: %1 | %2 | %3", _healer, _patient, _bodyPart] call vgm_g_fnc_logInfo;

// TODO progressbar
["vgm_medical_heal", [_healer, _patient, "fak", _bodyPart], [_patient]] call para_g_fnc_event_triggerTargets;
