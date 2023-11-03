/*
    File: fn_carry_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-11-03
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];

    if (_state) then {
        ["vgm_carry_enable", _unit] call para_g_fnc_event_triggerGlobal;
    } else {
        ["vgm_carry_disable", _unit] call para_g_fnc_event_triggerGlobal;
    };
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

}] call para_g_fnc_event_subscribeLocal;

["vgm_carry_disable", {
    (_this#0) params ["_unit"];


}] call para_g_fnc_event_subscribeLocal;
