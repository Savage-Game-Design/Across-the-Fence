/*
    File: fn_removeMagazineAmmo.sqf
    Author:
    Date: 2025-11-28
    Last Update: 2025-11-28
    Public: No

    Description:
        Removes a magazine from the unit with the specified ammo count. Must be run local to the unit.
        Won't remove a magazine from the weapon.

    Parameter(s):
        _unit - Unit to remove the magazine from [UNIT]
        _magazine - Magazine to remove, in the format [ className, ammoCount ] [ARRAY]

    Returns:
        Nothing

    Example(s):
        // Removes an m1911 magazine with 4 rounds in it
        [player, ["vn_1911_mag", 4]] call vgm_g_fnc_removeMagazineAmmo;
 */

params ["_unit", "_magazine"];
_magazine params ["_magType", "_magAmmo"];

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];
private _oldMagContainerIndex = _containers apply { magazinesAmmoCargo _x } findIf { [_magType, _magAmmo] in _x };

if (_oldMagContainerIndex > -1) then {
    private _oldMagContainer = _containers # _oldMagContainerIndex;
    _oldMagContainer addMagazineAmmoCargo [_magType, -1, _magAmmo];
};
