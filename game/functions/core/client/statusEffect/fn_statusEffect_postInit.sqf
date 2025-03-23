/*
    File: fn_statusEffect_preInit.sqf
    Author: Savage Game Design
    Date: 2024-12-07
    Last Update: 2024-12-14
    Public: No

    Description:
        Status effect client postInit.
 */

if (!hasInterface) exitWith {};

private _fnc_setCoreStatusEffects = {
    [player, "explosiveSpecialist", "core"] call vgm_c_fnc_statusEffect_set;
};

call _fnc_setCoreStatusEffects;
player addEventHandler ["Respawn", _fnc_setCoreStatusEffects];
