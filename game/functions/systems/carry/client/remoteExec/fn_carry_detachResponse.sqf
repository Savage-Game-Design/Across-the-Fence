/*
    File: fn_carry_detachResponse.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2023-12-01
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

params ["_unit", "_target"];

format ["Detached: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

_unit removeAction (_unit getVariable ["vgm_carry_actionDrop", -1]);

[_unit, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_remove;
