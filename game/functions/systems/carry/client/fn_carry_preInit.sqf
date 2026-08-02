/*
    File: fn_carry_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2026-01-09
    Public: No

    Description:
        Client preInit for carry component.
 */

if (!hasInterface) exitWith {};

// SOG Advanced Revive now handles carry/pickup/load for both players and AI targets.
// VGM carry hold actions are no longer needed.

// weapon lower/raise plays "put down" animation
// force to drop carried target to prevent abuse
addUserActionEventHandler ["toggleRaiseWeapon", "Activate", {
    private _unit = player;
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];
    if (isNull _target) exitWith {};
    [_unit, _target] remoteExec ["vgm_s_fnc_carry_detachRequest", 2];
}];
