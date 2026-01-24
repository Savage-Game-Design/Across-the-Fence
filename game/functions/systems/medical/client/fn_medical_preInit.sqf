#include "script_component.inc"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2026-01-24
    Public: No

    Description:
        Client preInit for medical component.
 */

if (!hasInterface) exitWith {};

["vgm_medical_addAction", {
    params ["_player"];
    _player call vgm_c_fnc_medical_addAction;
}] call para_g_fnc_event_subscribe;

vgm_medical_healItems = createHashMapFromArray [
    [HEAL_FAK, ["vn_helper_item_firstaidkit"]],
    [HEAL_MEDIKIT, ["vn_helper_item_medikit"]]
];

vgm_medical_healItemsTreatmentData = createHashMapFromArray [
    [HEAL_FAK, 1],
    [HEAL_MEDIKIT, 1]
];

["vgm_medical_heal", {
    (_this#0) params ["_healer", "_patient", "_itemType", "_bodyPart"];

    if (!local _patient) then {
        format ["Heal on non local unit: %1, %2", _healer, _patient] call vgm_g_fnc_logWarning;
    };

    private _canHeal = true;
    private _consumeItem = "";

    // check for required item
    if (!isNull _healer) then {
        private _requiredItems = vgm_medical_healItems get _itemType;
        private _foundItems = items _healer arrayIntersect _requiredItems;

        if (_foundItems isEqualTo []) exitWith {
            format ["Unable to heal, no item: %1 | %2 | %3", _healer, _patient, str _itemType] call vgm_g_fnc_logWarning;
            _canHeal = false;
        };

        if (_itemType == HEAL_FAK) then {
            if (
                (_healer getVariable ["vgm_c_skill_passives_support_resourceful", false]) // TODO consider coefficient?
                && {random 1 < 0.3}
            ) exitWith {format ["Not consuming item due to skill: %1 | %2 | %3", _healer, _patient, str _itemType] call vgm_g_fnc_logInfo};

            _consumeItem = _foundItems select 0;
        };
    };

    // prevent healing if no required item found
    if (!_canHeal) exitWith {};

    format ["Received heal: %1 | %2 | %3 | %4", _healer, _patient, str _itemType, str _consumeItem] call vgm_g_fnc_logInfo;

    _healer removeItem _consumeItem;
    ["vgm_medical_itemConsumed", [_healer, _consumeItem], _healer] call para_g_fnc_event_triggerTargets;

    private _woundsHealed = vgm_medical_healItemsTreatmentData getOrDefault [_itemType, 1];
    _woundsHealed = _woundsHealed + (_healer getVariable ["vgm_g_medical_healModifier", 0]);
    [_patient, _bodyPart, _woundsHealed] call vgm_c_fnc_medical_removeWound;

}] call para_g_fnc_event_subscribe;

["vgm_medical_adjustBleedoutAt", {
    (_this#0) params ["_unit", ["_adjust", nil, [0]]];

    if (!(_unit getVariable ["vgm_g_medical_bleeding", false])) exitWith {};

    format ["Adjusting bleed out time: %1 | %2", _unit, _adjust] call vgm_g_fnc_logInfo;

    private _bleedoutAt = _unit getVariable "vgm_c_medical_bleedoutAt";
    _unit setVariable ["vgm_c_medical_bleedoutAt", _bleedoutAt + _adjust];
    // visual bleeding effect, stops when `damage _unit` < 0.1
    _unit setBleedingRemaining (_bleedoutAt - time);

}] call para_g_fnc_event_subscribe;

["vgm_medical_stopBleeding", {
    (_this#0) params ["_unit"];

    format ["Stopping bleeding: %1", _unit] call vgm_g_fnc_logInfo;
    [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;

}] call para_g_fnc_event_subscribe;

["vgm_medical_fullHeal", {
    (_this#0) params ["_unit"];

    format ["Full heal: %1", _unit] call vgm_g_fnc_logInfo;
    [_unit] call vgm_c_fnc_medical_fullHeal;

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

["bleedOut", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_medical_coefficient_bleedout", _value max 0.5 min 3];
}] call vgm_c_fnc_coefficient_create;

["hitShrug", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_medical_coefficient_hitShrug", _value max 0 min 1];
}, 0] call vgm_c_fnc_coefficient_create;

["interact_medical", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_medical_coefficient_interact", _value max 0.1 min 5];
}] call vgm_c_fnc_coefficient_create;

["healModifier", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_g_medical_healModifier", _value max 0, true];
}, 0] call vgm_c_fnc_coefficient_create;

[{
    params ["_unit"];

    private _chance = _unit getVariable ["vgm_c_medical_coefficient_hitShrug", 0];
    if (random 1 < _chance) then {
        "Shrugging hit" call vgm_g_fnc_logDebug;
        _this set [2, 0];
        true // stop processing
    };
}] call vgm_c_fnc_medical_addDamageModifier;

[
    createHashMapFromArray [
        ["name", "OpenMedicalMenu"],
        ["displayName", "STR_VGM_MEDICAL_UI_OPEN_MEDICAL_MENU"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_H]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["OpenMedicalMenu", vgm_c_fnc_medical_openMedicalMenu] call para_c_fnc_keyhandler_addGeneralActionHandler;

[
    createHashMapFromArray [
        ["name", "OpenMedicalMenuSelf"],
        ["displayName", "STR_VGM_MEDICAL_UI_OPEN_MEDICAL_MENU_SELF"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["shift", true],
            ["dikCode", DIK_H]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["OpenMedicalMenuSelf", {[player] call vgm_c_fnc_medical_openMedicalMenu}] call para_c_fnc_keyhandler_addGeneralActionHandler;
