/*
    File: fn_trstate_whenChanged.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-02-10
    Public: Yes

    Description:
        Fires the provided handler when the state variable changes

    Parameter(s):
        _stateVariable - Variable to watch [ANY HASHMAP KEY]
        _callback - Callback, with parameters [ARRAY]

    Returns:
        ID which can be used to remove the handler [ANY]

    Example(s):
        ["Local_GamemodeStage", [[32], { DO THINGS }]] call para_g_fnc_trstate_whenChanged
 */

params ["_stateVariable", "_callback"];

private _trStateData = [] call para_g_fnc_trState_data;

private _stateChangedHandlers = _trstateData get "changedHandlers";
private _variableStateHandlers = _stateChangedHandlers getOrDefault [_stateVariable, [], true];

private _handlerId = ["changedHandlers", _stateVariable, _callback];
private _handler = [_handlerId, _callback];
_variableStateHandlers pushBack _handler;

/* Return ID for handler removal */
_handlerId
