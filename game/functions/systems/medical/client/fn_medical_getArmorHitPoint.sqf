/*
    File: fn_medical_getArmorHitPoint.sqf
    Author: Pterolatypus, modified by Savage Game Design
    Date: 2023-06-17
    Last Update: 2023-06-27
    Public: No

    Description:
        Get total amount of armor that is protecting given unit HitPoint.
        Based on: https://github.com/acemod/ACE3/blob/888ac6c9bcc4dd973a06f4bad06093cfdf391ef5/addons/medical_engine/functions/fnc_getHitpointArmor.sqf

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player, "hitchest"] call vgm_c_fnc_medical_getArmorHitPoint
 */

params ["_unit", "_hitPoint"];

private _uniform = uniform _unit;

// fallback to nakedUniform class if no uniform
if (_uniform isEqualTo "") then {
    _uniform = getText (configOf _unit >> "nakedUniform");
};

private _loadout = [
    _uniform,
    vest _unit,
    headgear _unit
];

private _fnc_getArmor = {
    #ifdef DEBUG
    format ["Fetching hitpoint armor: %1 | %2", _hitPoint, _loadout] call vgm_g_fnc_logDebug;
    #endif

    private _armor = 0;
    {
        _armor = _armor + ([_x, _hitPoint] call vgm_c_fnc_medical_getArmorItem);
    } forEach _loadout;

    _armor // return
};

private _key = _loadout + [_hitPoint];
vgm_c_medical_armorCache getOrDefaultCall [_key, _fnc_getArmor, true] // return
