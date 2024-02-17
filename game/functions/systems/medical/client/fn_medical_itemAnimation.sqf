/*
    File: fn_medical_itemAnimation.sqf
    Author: Savage Game Design
    Date: 2023-11-25
    Last Update: 2023-12-02
    Public: No

    Description:
        Start playback of item animation and set final animation on the healer for itemApply function.

    Parameter(s):
        _healer   - Unit doing the healing [OBJECT]
        _patient  - Unit being healed [OBJECT]
        _itemTime - How long it takes to apply the item [NUMBER]

    Returns:
        Nothing

    Example(s):
        [player, player, 7] call vgm_c_fnc_medical_itemAnimation
 */

params ["_healer", "_patient", "_itemTime"];

// do not play in vehicles
if (!(_healer in _healer)) exitWith {};

private _pos = ["knl", "pne"] select (stance _healer isEqualTo "PRONE");
private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _healer, secondaryWeapon _healer, handgunWeapon _healer] find currentWeapon _healer, "non"];
private _stn = ["ras", "low"] select weaponLowered _healer;

private _anim = ["AinvP%1MstpSlayW%2Dnon_medic", "AinvP%1MstpSlayW%2Dnon_medicOther"] select (_healer != _patient);
_anim = format [_anim, _pos, _wpn];

private _animDone = format ["AmovP%1MstpS%2W%3Dnon", _pos, _stn, _wpn];

// get anim duration, negative "speed" is anim duration in seconds
private _animDuration = abs getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> _anim >> "speed");

_healer setVariable ["vgm_c_medical_itemDoneAnim", _animDone];

// temporarily force animation speed
[_healer, "animSpeed", "medical_item", true] call vgm_c_fnc_coefficient_override;
_healer setAnimSpeedCoef (_animDuration / _itemTime);

_healer playMoveNow _anim;
