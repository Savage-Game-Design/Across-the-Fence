/*
    File: fn_director_addAlertness.sqf
    Author: Savage Game Design
    Date: 2025-08-30
    Last Update: 2025-08-30
    Public: No

    Description:
        Adds alertness to the current mission

    Parameter(s):
        _director - Director to add alertness to [HASHMAP]
        _alertnessGain - Alertness to add [NUMBER]

    Returns:
        New total alertness [NUMBER]

    Example(s):
        [10] call vgm_s_fnc_director_addAlertness;
 */

params ["_director", "_alertnessGain"];

private _newAlertness = ((_director get "alertness") + _alertnessGain) min vgm_s_director_max_alertness max 0;

_director set ["alertness", _newAlertness];

_newAlertness
