#include "script_component.inc"
/*
    File: fn_medical_unitInit.sqf
    Author: Savage Game Design
    Date: 2023-12-03
    Last Update: 2023-12-03
    Public: No

    Description:
        Enable custom medical system on an unit.

    Parameter(s):
        _unit - Unit to enable the medical system on [OBJECT]

    Returns:
        Nothing

    Example(s):
        player call vgm_c_fnc_medical_unitInit
 */

params ["_unit"];

if (!isNil {_unit getVariable "vgm_c_medical_handleDamageEH"}) exitWith {
    format ["Unit medical already initialized: %1", _unit] call vgm_g_fnc_logError;
};

format ["Initializing unit medical: %1", _unit] call vgm_g_fnc_logInfo;

_unit setVariable ["vgm_c_medical_lastHitAt", createHashMapFromArray (BODY_PARTS_ARR apply {[_x, -1]})];

private _handleDamageEH = _unit addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];
private _respawnEH  = _unit addEventHandler ["Respawn", {
    params ["_unit"];
    {_unit setVariable [_x, nil]} forEach (allVariables _unit select {_x find "vgm_g_medical_wound$" == 0});
}];

_unit setVariable ["vgm_c_medical_handleDamageEH", _handleDamageEh];
_unit setVariable ["vgm_c_medical_respawnEH", _respawnEH];

// tell other clients to add actions on unit
["vgm_medical_addAction", _unit] call para_g_fnc_event_triggerGlobal;
private _respawnActionsEH = _unit addEventHandler ["Respawn", {
    ["vgm_medical_addAction", _this#0] call para_g_fnc_event_triggerGlobal;
}];

_unit setVariable ["vgm_c_medical_respawnActionsEH", _respawnActionsEH];
