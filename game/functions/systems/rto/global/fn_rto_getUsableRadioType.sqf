/*
    File: fn_rto_getUsableRadioType.sqf
    Author: Savage Game Design (based on Ethan Johnson's original)
    Date: 2026-01-25
    Last Update: 2026-03-08
    Public: No

    Description:
        Function to determine if the player has access to the radio operator menu

    Parameter(s):
        _unit - Unit making the request [OBJECT, defaults to player]

    Returns:
        Gets the type of radio the player has available. One of "BACKPACK", "HANDHELD", "" [STRING]

    Example(s):
        [player] call vgm_g_fnc_rto_getUsableRadioType;
 */

#define RADIO_SLOT 611

params [["_unit", player,[objnull]]];

if (_unit getUnitTrait "vgm_radio_operator" && { backpack _unit in vgm_g_rto_radioBackpacks }) exitWith {
    "BACKPACK"
};

// Unit has no usable backpack radio, and can't use a handheld.
if !(_unit getUnitTrait "vgm_radio_operator_handheld") exitWith { "" };

private _radio = _unit getSlotItemName RADIO_SLOT;
if (_radio isEqualTo "") exitWith { "" };

if (_radio in vgm_g_rto_radioItems) exitWith { "HANDHELD" };

// Handles TFAR radios, which are subclassed from the parent
private _parentRadio = configName inheritsFrom (configFile >> "CfgWeapons" >> _radio);
if (_parentRadio in vgm_g_rto_radioItems) exitWith { "HANDHELD" };

""
