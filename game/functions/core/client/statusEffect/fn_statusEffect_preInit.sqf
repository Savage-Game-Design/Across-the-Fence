/*
    File: fnc_preInit.sqf
    Author: Savage Game Design
    Date: 2023-07-02
    Last Update: 2023-07-12
    Public: No

    Description:
        Status effect client preInit.
 */

if (!hasInterface) exitWith {};

["forceWalk", {
    params ["_unit", "_inEffect"];
    _unit forceWalk _inEffect;
}] call vgm_c_fnc_statusEffect_create;

["forceJog", {
    params ["_unit", "_inEffect"];
    _unit allowSprint !_inEffect;
}] call vgm_c_fnc_statusEffect_create;
