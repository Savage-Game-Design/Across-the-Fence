#include "script_component.inc"
/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-12-03
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

    [_patient, _bodyPart, vgm_medical_healItemsTreatmentData get _itemType] call vgm_c_fnc_medical_removeWound;

}] call para_g_fnc_event_subscribe;

["vgm_medical_adjustBleedOutAt", {
    (_this#0) params ["_unit", ["_adjust", nil, [0]]];

    if (!(_unit getVariable ["vgm_g_medical_bleeding", false])) exitWith {};

    format ["Adjusting bleed out time: %1 | %2", _unit, _adjust] call vgm_g_fnc_logInfo;

    private _bleedOutAt = _unit getVariable "vgm_c_medical_bleedOutAt";
    _unit setVariable ["vgm_c_medical_bleedOutAt", _bleedOutAt + _adjust];
    // visual bleeding effect, stops when `damage _unit` < 0.1
    _unit setBleedingRemaining (_bleedOutAt - time);

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

[{
    params ["_unit"];

    private _chance = _unit getVariable ["vgm_c_medical_coefficient_hitShrug", 0];
    if (random 1 < _chance) then {
        "Shrugging hit" call vgm_g_fnc_logDebug;
        _this set [2, 0];
        true // stop processing
    };
}] call vgm_c_fnc_medical_addDamageModifier;
