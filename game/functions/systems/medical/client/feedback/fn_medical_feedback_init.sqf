/*
    File: fn_medical_feedbackInit.sqf
    Author: Savage Game Design
    Date: 2023-07-24
    Last Update: 2023-08-18
    Public: No

    Description:
        Initialize medical feedback system.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_feedback_init
 */

["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];
    if (_state || {_unit == player}) exitWith {};
    -1 call vgm_c_fnc_medical_feedbackBleeding;
}] call para_g_fnc_event_subscribe;

player addEventHandler ["Killed", {
    -1 call vgm_c_fnc_medical_feedbackBleeding;
}];
