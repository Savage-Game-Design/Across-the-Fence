#include "script_component.inc"
/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-07-23
    Public: No

    Description:
        Client preInit for medical component.
 */

if (!hasInterface) exitWith {};

["vgm_medical_addAction", {
    params ["_player"];
    if (_player getVariable ["vgm_c_medical_actions", false]) exitWith {};
    _player setVariable ["vgm_c_medical_actions", true];

    private _text = ["str_a3_cfgactions_healsoldierauto0", "str_a3_cfgactions_healsoldierself0"] select (player == _player);
    _player addAction [localize _text, {
        params ["_target"];
        _target call vgm_c_fnc_medical_openMedicalMenu;
    }];

}] call para_g_fnc_event_subscribe;

["vgm_medical_heal", {
    (_this#0) params ["_healer", "_patient", "_itemType", "_bodyPart"];
    if (!isNull _healer) then {
        // check if healer has required item and consume it
    };

    format ["Received heal: %1 | %2 | %3", _healer, _patient, str _itemType] call vgm_g_fnc_logInfo;

    [_patient, _bodyPart, [2, 1] select (_itemType == "medikit")] call vgm_c_fnc_medical_removeWound;

}] call para_g_fnc_event_subscribe;

// maps hitpoint to our virtual body parts handled by our medical system
vgm_c_medical_hitPointBodyPartMap = createHashMapFromArray [
    ["hitface", BODY_PART_HEAD],
    ["hitneck", BODY_PART_HEAD],
    ["hithead", BODY_PART_HEAD],
    // arms
    ["hitarms", BODY_PART_ARMS],
    ["hithands", BODY_PART_ARMS],
    // torso
    ["hitbody", BODY_PART_TORSO],
    ["hitpelvis", BODY_PART_TORSO],
    ["hitchest", BODY_PART_TORSO],
    ["hitabdomen", BODY_PART_TORSO],
    ["hitdiaphragm", BODY_PART_TORSO],
    // legs
    ["hitlegs", BODY_PART_LEGS]
];

vgm_c_medical_armorCache = createHashMap;
vgm_c_medical_damageModifiers = [];

