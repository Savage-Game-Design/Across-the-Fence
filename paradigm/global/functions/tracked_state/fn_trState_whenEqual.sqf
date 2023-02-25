/*
    File: fn_trstate_whenEqual.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-02-25
    Public: Yes

    Description:
        Fires the provided handler when the state variable's hashed value matches
        the hash of the given value.

        Fires immediately if the state already matches.

    Parameter(s):
        _stateVariable - Variable to watch [ANY HASHMAP KEY]
        _valueToMatch - Value to check for equality against [ANY HASHABLE]
        _callback - Callback, with parameters [ARRAY]

    Returns:
        ID which can be used to remove the handler [ANY]

    Example(s):
        ["Local_GamemodeStage", "Starting", [[32], { DO THINGS }]] call para_g_fnc_trstate_whenEqual
 */

params ["_stateVariable", "_valueToMatch", "_callback"];

private _trStateData = [] call para_g_fnc_trState_data;

private _valueHash = hashValue _valueToMatch;

private _stateEqualsHandlers = _trStateData get "equalsHandlers";
private _variableStateHandlers = _stateEqualsHandlers getOrDefault [_stateVariable, createHashMap, true];
private _matchingValueHandlers = _variableStateHandlers getOrDefault [_valueHash, [], true];

private _handlerId = ["equalsHandlers", _stateVariable, _valueHash, _callback];
private _handler = [_handlerId, _callback];
_matchingValueHandlers pushBack _handler;

private _currentValue = _trStateData get "state" get _stateVariable;
if (!isNil "_currentValue" && { hashValue _currentValue isEqualTo _valueHash }) then {
    [
        [_handler],
        _stateVariable,
        _currentValue,
        _currentValue
    ] call para_g_fnc_trState_callHandlers;
};

/* Return ID for handler removal */
_handlerId
