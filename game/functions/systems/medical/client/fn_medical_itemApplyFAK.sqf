#include "script_component.inc"
/*
    File: fn_medical_itemApplyFAK.sqf
    Author: Savage Game Design
    Date: 2023-06-30
    Last Update: 2023-08-19
    Public: No

    Description:
        Apply First Aid Kit to the patient.

    Parameter(s):
        _healer - Unit doing the healing [OBJECT]
        _patient - Unit being healed [OBJECT]
        _bodyPart - Body part that is being healed [STRING]

    Returns:
        Nothing

    Example(s):
        [player, cursorObject, "head"] call vgm_c_fnc_medical_itemApplyFAK
 */

params ["_healer", "_patient", "_bodyPart"];

format ["Applying FAK: %1 | %2 | %3", _healer, _patient, _bodyPart] call vgm_g_fnc_logInfo;

private _treatmentTime = 3; // TODO compute the value

[format [localize "STR_VGM_MEDICAL_UI_APPLY_FAK", name _patient], _treatmentTime, {
    params ["_args", "_startedAt", "_duration"];
    _args params ["_healer", "_patient"];

    if (_healer distance _patient > 5) exitWith {
        hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_PATIENT_TOO_FAR"; // TODO custom notification system?
        false // return
    };

    private _requiredItems = vgm_medical_healItems get HEAL_FAK;
    if (items _healer arrayIntersect _requiredItems isEqualTo []) exitWith {
        hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_MISSING_ITEMS"; // TODO custom notification system?
        false // return
    };

    true // return
}, {
    params ["_args", "_startedAt", "_duration"];
    _args params ["_healer", "_patient", "_bodyPart"];

    ["vgm_medical_heal", [_healer, _patient, HEAL_FAK, _bodyPart], [_patient]] call para_g_fnc_event_triggerTargets;
}, {}, [_healer, _patient, _bodyPart]] call vgm_c_fnc_progressBar;
