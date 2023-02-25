/*
    File: fn_trackedState_callHandlers.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-02-25
    Public: No

    Description:
        Calls the given handlers with the given parameters.

    Parameter(s):
        _handlers - Array of handlers to call, with each handler in the format [arguments, code] [ARRAY]
        _stateVariable - State variable that's being observed [ANY HASHMAP KEY]
        _currentValue - Current value of the state variable [ANY HASHABLE]
        _oldValue - Old value of the state variable, may be nil [ANY HASHABLE]

    Returns:
        Nothing

    Example(s):
        [
            [
                [[1,2,3], { // Handler code }],
            ],
            "Local_GamemodeStatus",
            "Starting",
            "Warmup"
        ] call para_g_fnc_trackedState_callHandlers;
 */

params ["_handlers", "_stateVariable", "_currentValue", "_oldValue"];

{
    _x params ["_thisHandlerId", "_handler"];
    [_stateVariable, _currentValue, _oldValue, _handler # 0] call (_handler # 1);
} forEach _handlers;

