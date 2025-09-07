/*
    File: fn_extension_call.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-08-27
    Public: Yes

    Description:
        Calls Across the Fence extension.

    Parameter(s):
        _function - Function of the extension to call [STRING]
        _args - Arguments to pass to the function [ARRAY]

    Returns:
        Extension result data [ARRAY]

    Example(s):
        (["persistence:connect", []] call vgm_s_fnc_extension_call) params ["_result", "_isSuccess"];
 */


params [["_function", "", [""]], ["_args", [], [[]]]];

format ["Extension function call: %1", _function] call vgm_g_fnc_logDebug;

("atf_backend" callExtension [_function, _args]) params ["_result", "_extensionCode", "_armaCode"];

private _success = true;

if (_armaCode != 0 && _armaCode != 301) then {
    _success = false;
    // https://community.bistudio.com/wiki/callExtension
    private _armaCodeMessage = createHashMapFromArray [
        [101, "SYNTAX_ERROR_WRONG_PARAMS_SIZE"],
        [102, "SYNTAX_ERROR_WRONG_PARAMS_TYPE"],
        [201, "PARAMS_ERROR_TOO_MANY_ARGS"],
        // [301, "EXECUTION_WARNING_TAKES_TOO_LONG"],
        [400, "EXTENSION_LOAD_FAILED"],
        [403, "EXTENSION_BLOCKED_BY_BATTLEYE"],
        [404, "EXTENSION_NOT_FOUND"]
    ] getOrDefault [_armaCode, format ["UNKNOWN_%1", _armaCode]];

    _armaCodeMessage call vgm_g_fnc_logError;
};

if (_extensionCode != 0) then {
    _success = false;
    if (_extensionCode == -1) exitWith {
        "extension not available" call vgm_g_fnc_logError;
    };
    // https://github.com/BrettMayson/arma-rs?tab=readme-ov-file#error-codes
    if (_extensionCode == 9) exitWith {
        format ["atf_backend error: %1", _result] call vgm_g_fnc_logError;
    };

    format ["arma-rs error: %1", _extensionCode] call vgm_g_fnc_logError;
};

[_result, _success] // return
