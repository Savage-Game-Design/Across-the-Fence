/*
    File: fn_db_backend_get.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Request was accepted [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_schema", "_id", "_fnc_handler", "_arguments"];

private _response = [format ["persistence:%1:get", _schema], [_id]] call vgm_s_fnc_extension_call;
_response params ["_callbackId", "_success"];

if (!_success) exitWith {false};

vgm_db_backend_callbackHandlers get _schema set [_callbackId, [_fnc_handler, _arguments]];

true
