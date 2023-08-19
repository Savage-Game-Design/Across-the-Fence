#include "script_component.inc"
/*
    File: fn_stamina_preInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2023-08-19
    Public: No

    Description:
        Client preInit for stamina component.
 */

if (!hasInterface) exitWith {};

vgm_stamina_stanceCoef = createHashMapFromArray [
    ["STAND", COEF_STD],
    ["CROUCH", COEF_KNL],
    ["PRONE", COEF_PNE]
];
