/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-11
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

if (!hasInterface) exitWith {};

["vgm_medical_addAction", {
    params ["_player"];
    if (player == _player || {_player getVariable ["vgm_c_medical_actions", false]}) exitWith {};
    _player setVariable ["vgm_c_medical_actions", true];

    _player addAction ["Heal", {}];

}] call para_g_fnc_event_subscribe;

addUserActionEventHandler ["Help", "Activate", {

}];
