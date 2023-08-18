/*
    File: fn_stamina_postInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2023-08-18
    Public: No

    Description:
        Client postInit for stamina component.
 */

if (!hasInterface) exitWith {};

player call vgm_c_fnc_stamina_unitInit;
