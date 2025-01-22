/*
    File: fn_stealth_addPlayerFiredEH.sqf
    Author: Savage Game Design
    Date: 2025-01-22
    Last Update: 2025-01-22
    Public: No

    Description:
        Makes the player visible when they fire.

    Parameter(s):
        _unit - Unit to add EH to [UNIT]

    Returns:
        Event handler ID [NUMBER]

    Example(s):
        [player] call vgm_c_fnc_stealth_addPlayerFiredEH;
 */

#define HANDLER_VAR "vgm_c_stealth_playerFiredEh"

params ["_unit"];

private _ehId = _unit getVariable [HANDLER_VAR, -1];
if (_ehId > -1) exitWith {_ehId};

// Use "FiredMan" instead of "Fired" in case they're in a static weapon.
_ehId = _unit addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "", "", "", "", ""];

    if (_weapon in ["Put"]) exitWith {};

    [vgm_c_stealth_visibleOnFiredDelay, vgm_c_stealth_visibleDurationOnFired] call vgm_c_fnc_stealth_setVisibleForDurationAfterDelay;
}];

_unit setVariable [HANDLER_VAR, _ehId];

_ehId // return

