/*
    File: fn_trackedState_getValue.sqf
    Author: Savage Game Design
    Date: 2023-03-06
    Last Update: 2023-03-06
    Public: Yes

    Description:
        Gets the value of a variable from the tracked state system.

    Parameter(s):
        _stateVariable - Variable to get [ANY HASHMAP KEY]
        _defaultValue - Value to return if the state is nil [ANY]

    Returns:
        Current value of the state associated with _stateVariable [ANY]

    Example(s):
        ["Goldfish"] call para_g_fnc_trackedState_getValue;
 */

params ["_stateVariable", "_defaultValue"];

private _trStateData = [] call para_g_fnc_trackedState_getData;

_trStateData get "state" get [_stateVariable, _defaultValue]
