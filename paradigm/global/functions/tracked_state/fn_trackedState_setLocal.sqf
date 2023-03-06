/*
    File: fn_trackedState_setLocal.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-03-06
    Public: No

    Description:
        Set the local tracked state variable to the provided value, and invokes any handlers.

    Parameter(s):
        _stateVariable - Variable to set [ANY HASHMAP KEY]
        _value - Value to set variable to [ANY]
        _reason - Reason the value is being updated, this allows arbitrary data to be passed to the handlers for this update only. [ANY]

    Returns:
        Nothing

    Example(s):
        ["Local_GamemodeStage", "Starting"] call para_g_fnc_trackedState_setLocal;
 */

params ["_stateVariable", "_newValue", "_reason"];

private _trStateData = [] call para_g_fnc_trackedState_getData;

private _state = _trStateData get "state";
// Shouldn't matter if this is nil, as long as it's only used in arrays
private _oldValue = _state get _stateVariable;

// Don't check for equality here - it breaks if we mutate the state elsewhere, as it would see it as "equal".
// We need to be able to mutate (e.g arrays, hashmaps) to avoid the awful performance of hashmaps

_state set [_stateVariable, _newValue];

private _changedHandlers =
    _trStateData get "changedHandlers"
    getOrDefault [_stateVariable, []];

private _equalsHandlers =
    _trStateData get "equalsHandlers"
    getOrDefault [_stateVariable, createHashMap, true]
    getOrDefault [hashValue _newValue, []];

[
    _changedHandlers + _equalsHandlers,
    _stateVariable,
    _newValue,
    _oldValue,
    _reason
] call para_g_fnc_trackedState_callHandlers;
