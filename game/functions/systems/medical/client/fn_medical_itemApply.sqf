/*
    File: fn_medical_itemApply.sqf
    Author: Savage Game Design
    Date: 2023-08-20
    Last Update: 2026-01-24
    Public: No

    Description:
        Apply medical item to the patient.

    Parameter(s):
        _healer - Unit doing the healing [OBJECT]
        _patient - Unit being healed [OBJECT]
        _bodyPart - Body part that is being healed [STRING]
        _itemData - Hashmap with item data [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [player, cursorObject, "head", createHashMapFromArray [
            ["type", "fak"],
            ["time", 3],
            ["displayName", "fak"]
        ]] call vgm_c_fnc_medical_itemApply
 */

params ["_healer", "_patient", "_bodyPart", "_itemData"];

if (!isNull (_healer getVariable ["vgm_carry_carriedObject", objNull])) exitWith {
    format ["Cannot apply medical item while carrying an object: %1", _healer] call vgm_g_fnc_logError;
    hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_CARRYING_OBJECT"; // TODO custom notification system?
};

format ["Applying item: %1 | %2 | %3 | %4", _healer, _patient, _bodyPart, _itemData] call vgm_g_fnc_logDebug;

private _coefInteract = _healer getVariable ["vgm_c_coefficient_interact", 1];
private _coefInteractMedical = _healer getVariable ["vgm_c_medical_coefficient_interact", 1];

private _time = (_itemData get "time") * _coefInteract * _coefInteractMedical;

[_healer, _patient, _time] call vgm_c_fnc_medical_itemAnimation;

[format [_itemData get "displayName", name _patient], _time, {
    params ["_args", "_startedAt", "_duration"];
    _args params ["_healer", "_patient", "", "_itemData"];

    if (_healer call vgm_g_fnc_medical_isUnconscious) exitWith {
        false // return
    };

    if (_healer distance _patient > 5) exitWith {
        hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_PATIENT_TOO_FAR"; // TODO custom notification system?
        false // return
    };

    private _requiredItems = vgm_medical_healItems get (_itemData get "type");
    if (items _healer findAny _requiredItems == -1) exitWith {
        hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_MISSING_ITEMS"; // TODO custom notification system?
        false // return
    };

    true // return
}, {
    params ["_args", "_startedAt", "_duration"];
    _args params ["_healer", "_patient", "_bodyPart", "_itemData"];

    ["vgm_medical_heal", [_healer, _patient, _itemData get "type", _bodyPart], [_patient]] call para_g_fnc_event_triggerTargets;

    [_patient] spawn {
        sleep 0.1;
        params ["_patient"];
        // do not reopen for fully healed, might not work on remote units due to network delay
        if ([_patient, "total"] call vgm_c_fnc_medical_getWound < 1) exitWith {
            hint localize "STR_VGM_MEDICAL_UI_NOTIFICATION_PATIENT_HEALTHY";
        };
        _patient call vgm_c_fnc_medical_openMedicalMenu;
    };

    // do not force animation speed anymore
    [_healer, "animSpeed", "medical_item", false] call vgm_c_fnc_coefficient_override;
    _healer playMoveNow (_healer getVariable "vgm_c_medical_itemDoneAnim");
}, {
    (_this#0) params ["_healer", "_patient"];

    if !(_healer call vgm_g_fnc_medical_isUnconscious) then {
        [_patient] spawn vgm_c_fnc_medical_openMedicalMenu;
        _healer switchMove (_healer getVariable "vgm_c_medical_itemDoneAnim");
    } else {
        // prevent a bug where healing animations starts playing few seconds after being downed
        // (game seems to remember it being played during being downed)
        _healer switchMove "";
    };

    // do not force animation speed anymore
    [_healer, "animSpeed", "medical_item", false] call vgm_c_fnc_coefficient_override;
}, [_healer, _patient, _bodyPart, _itemData]] call vgm_c_fnc_progressBar;
