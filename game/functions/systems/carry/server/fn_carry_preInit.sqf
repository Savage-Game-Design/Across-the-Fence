/*
    File: fn_carry_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-12-06
    Public: No

    Description:
        Server preInit for carry component.
 */

if (!isServer) exitWith {};

addMissionEventHandler ["HandleDisconnect", {
    params ["_unit"];
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];
    if (isNull _target) exitWith {};

    // drop carried unit when carrier disconnects
    [objNull, _target] call vgm_s_fnc_carry_detachRequest;

    // if this EH code returns true... player... becomes AI
    // https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#HandleDisconnect
    false
}];

addMissionEventHandler ["EntityKilled", {
    params ["_unit"];
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];
    if (isNull _target) exitWith {};

    // drop carried unit when carrier is killed
    [_unit, _target] call vgm_s_fnc_carry_detachRequest;
}];

["vgm_carry_enable", {
    (_this#0) params ["_unit"];
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];
    if (isNull _target) exitWith {};

    // drop carried unit when carrier goes unconscious
    [_unit, _target] call vgm_s_fnc_carry_detachRequest;
}] call para_g_fnc_event_subscribe;

["vgm_carry_disable", {
    (_this#0) params ["_target"];
    private _unit = _target getVariable ["vgm_carry_carriedBy", objNull];
    if (isNull _unit) exitWith {};

    // force target to be put down when it wakes up
    [_unit, _target] call vgm_s_fnc_carry_detachRequest;
}] call para_g_fnc_event_subscribe;
