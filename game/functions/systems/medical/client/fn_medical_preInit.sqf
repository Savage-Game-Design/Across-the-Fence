#include "script_component.inc"
/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-27
    Public: No

    Description:
        Client preInit for medical component.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["vgm_medical_addAction", {
    params ["_player"];
    if (player == _player || {_player getVariable ["vgm_c_medical_actions", false]}) exitWith {};
    _player setVariable ["vgm_c_medical_actions", true];

    _player addAction ["Heal", {}];

}] call para_g_fnc_event_subscribe;

addUserActionEventHandler ["Help", "Activate", {
    [] call vgm_c_fnc_medical_openMedicalMenu;
}];

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
