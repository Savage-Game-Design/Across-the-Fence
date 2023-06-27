#include "script_component.inc"
/*
    File: fn_medical_getArmorItem.sqf
    Author: Pterolatypus, modified by Savage Game Design
    Date: 2023-06-18
    Last Update: 2023-06-27
    Public: No

    Description:
        Get amount of armor the item has for the given hitpoint.
        Based on: https://github.com/acemod/ACE3/blob/888ac6c9bcc4dd973a06f4bad06093cfdf391ef5/addons/medical_engine/functions/fnc_getItemArmor.sqf

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        ["vn_b_vest_usmc_01", "hitchest"] call vgm_c_fnc_medical_getArmorItem
 */

private _fnc_getArmor = {
    // wrap in call to prevent issues with getOrDefaultCall
    call {
        params ["_item", "_hitPoint"];

        #ifdef DEBUG
        format ["Calculating item armor: %1 | %2", str _item, _hitPoint] call vgm_g_fnc_logDebug;
        #endif

        if ("" in [_item, _hitPoint]) exitWith {0};

        private _itemInfo = configFile >> "CfgWeapons" >> _item >> "ItemInfo";

        if (getNumber (_itemInfo >> "type") == TYPE_UNIFORM) exitWith {
            private _unitCfg = configFile >> "CfgVehicles" >> getText (_itemInfo >> "uniformClass");

            if (_hitPoint == "#structural") exitWith {
                getNumber (_unitCfg >> "armorStructural") // return
            };

            private _entry = _unitCfg >> "HitPoints" >> _hitPoint;
            getNumber (_unitCfg >> "armor") * (1 max getNumber (_entry >> "armor")) // return
        };

        private _condition = format ["getText (_x >> 'hitpointName') == '%1'", _hitPoint];
        private _entry = configProperties [_itemInfo >> "HitpointsProtectionInfo", _condition] param [0, configNull];

        getNumber (_entry >> "armor") // return
    };
};

vgm_c_medical_armorCache getOrDefaultCall [_this, _fnc_getArmor, true] // return
