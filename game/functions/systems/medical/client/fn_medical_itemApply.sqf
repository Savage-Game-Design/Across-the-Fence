/*
    File: fn_medical_itemApply.sqf
    Author: Savage Game Design
    Date: 2023-08-20
    Last Update: 2023-11-26
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

format ["Applying item: %1 | %2 | %3 | %4", _healer, _patient, _bodyPart, _itemData] call vgm_g_fnc_logDebug;

private _time = (_itemData get "time") * ([_healer, "interact"] call vgm_c_fnc_coefficient_get);

[_healer, _patient, _time] call vgm_c_fnc_medical_itemAnimation;

[format [_itemData get "displayName", name _patient], _time, {
    params ["_args", "_startedAt", "_duration"];
    _args params ["_healer", "_patient", "", "_itemData"];

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

    [_patient] spawn vgm_c_fnc_medical_openMedicalMenu;

    // do not force animation speed anymore
    [_healer, "animSpeed", "medical_item", false] call vgm_c_fnc_coefficient_override;
    _healer playMoveNow (_healer getVariable "vgm_c_medical_itemDoneAnim");
}, {
    (_this#0) params ["_healer", "_patient"];
    [_patient] spawn vgm_c_fnc_medical_openMedicalMenu;

    // do not force animation speed anymore
    [_healer, "animSpeed", "medical_item", false] call vgm_c_fnc_coefficient_override;
    _healer switchMove (_healer getVariable "vgm_c_medical_itemDoneAnim");
}, [_healer, _patient, _bodyPart, _itemData]] call vgm_c_fnc_progressBar;
