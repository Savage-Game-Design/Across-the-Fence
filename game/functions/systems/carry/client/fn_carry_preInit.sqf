/*
    File: fn_carry_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-12-01
    Public: No

    Description:
        Client preInit for carry component.
 */

if (!hasInterface) exitWith {};

["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];

    [["vgm_carry_disable", "vgm_carry_enable"] select _state, _unit] call para_g_fnc_event_triggerGlobal;
}] call para_g_fnc_event_subscribeLocal;

["vgm_carry_enable", {
    (_this#0) params ["_unit"];

    private _action = _unit addAction [
        format ["<t color='#ed872d'>%1</t>", localize "STR_VN_REVIVE_ACTION_PICKUP"],
        {
            params ["_target", "_unit"];
            [_unit, _target] call vgm_c_fnc_carry_doCarry;
        },
        nil,
        100,
        true,
        true,
        "",
        "[_this, _originalTarget] call vgm_c_fnc_carry_canCarry",
        3
    ];
    _unit setVariable ["vgm_carry_actionCarry", _action];

}] call para_g_fnc_event_subscribe;

["vgm_carry_disable", {
    (_this#0) params ["_target"];
    private _unit = _target getVariable ["vgm_carry_carriedBy", objNull];

    _unit removeAction (_unit getVariable ["vgm_carry_actionCarry", -1]);
}] call para_g_fnc_event_subscribe;
