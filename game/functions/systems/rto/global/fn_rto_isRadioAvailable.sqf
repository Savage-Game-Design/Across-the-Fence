/*
    File: fn_rto_isRadioAvailable.sqf
    Author: Savage Game Design (based on Ethan Johnson's original)
    Date: 2026-01-25
    Last Update: 2026-01-25
    Public: No

    Description:
        Function to determine if the player has access to the radio operator menu

    Parameter(s):
        _unit - Unit making the request [OBJECT, defaults to player]

    Returns:
        True is the player has access to the menu [BOOL]

    Example(s):
        [player] call vgm_g_fnc_rto_isRadioAvailable;
 */

params [["_unit", player,[objnull]]];

backpack _unit in vgm_g_rto_radioBackpacks
    && _unit getUnitTrait "vgm_radio_operator"

