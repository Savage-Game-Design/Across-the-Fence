/*
    File: fn_medical_itemApplyFAK.sqf
    Author: Savage Game Design
    Date: 2023-06-30
    Last Update: 2023-07-23
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

// TODO progressbar
["vgm_medical_heal", [_healer, _patient, "fak", _bodyPart], [_patient]] call para_g_fnc_event_triggerTargets;
