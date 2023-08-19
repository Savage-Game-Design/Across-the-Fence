#include "script_component.inc"
/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-08-19
    Public: No

    Description:
        Client preInit for medical component.
 */

if (!hasInterface) exitWith {};

["vgm_medical_addAction", {
    params ["_player"];
    if (_player getVariable ["vgm_c_medical_actions", false]) exitWith {};
    _player setVariable ["vgm_c_medical_actions", true];

    private _fnc_addAction = {
        params ["_player"];

        private _text = ["str_a3_cfgactions_healsoldierauto0", "str_a3_cfgactions_healsoldierself0"] select (player == _player);
        private _actionId = _player addAction [localize _text, {
            params ["_target"];
            _target call vgm_c_fnc_medical_openMedicalMenu;
        }, nil, 1, false];

        _player setVariable ["vgm_medical_actionHeal", _actionId];
    };

    _player call _fnc_addAction;
    _player addEventHandler ["Respawn", _fnc_addAction];
    _player addEventHandler ["Killed", {
        params ["_player"];
        _player removeAction (_player getVariable ["vgm_medical_actionHeal", -1]);
        _player setVariable ["vgm_medical_actionHeal", nil];
    }]

}] call para_g_fnc_event_subscribe;

vgm_medical_healItems = createHashMapFromArray [
    [HEAL_FAK, ["vn_b_item_firstaidkit", "vn_o_item_firstaidkit"]],
    [HEAL_MEDIKIT, ["vn_b_item_medikit_01"]]
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
            _consumeItem = _foundItems select 0;
        };
    };

    // prevent healing if no required item found
    if (!_canHeal) exitWith {};

    format ["Received heal: %1 | %2 | %3 | %4", _healer, _patient, str _itemType, str _consumeItem] call vgm_g_fnc_logInfo;

    _healer removeItem _consumeItem;

    [_patient, _bodyPart, [2, 1] select (_itemType == HEAL_MEDIKIT)] call vgm_c_fnc_medical_removeWound;

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

