/*
    File: fn_extension_setHandler.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-08-27
    Public: Yes

    Description:
        Set handler for extension function callbacks.

    Parameter(s):
        _function - Name of the function to handle callbacks for [STRING]
        _callback - Function to use as callback handler [CODE]
        _arguments - Custom arguments to pass to the handler [ARRAY]

    Returns:
        Handler was set [BOOL]

    Example(s):
        ["leveling:get", {
            params ["_resultStr", "_data"];
            systemChat format ["leveling data: %1", _data];
        }] call vgm_s_fnc_extension_setHandler
 */

params [
    ["_function", "", [""]],
    ["_callback", {}, [{}]],
    ["_arguments", [], [[]]]
];

if (_function isEqualTo "") exitWith {
    "Function name not specified, handler not set!" call vgm_g_fnc_logError;
    false
};

if (_callback isEqualTo {}) exitWith {
    "Callback not specified, handler not set!" call vgm_g_fnc_logError;
    false
};

if (isNil "vgm_s_extension_handlers") then {
    vgm_s_extension_handlers = createHashMap;
};

vgm_s_extension_handlers set [format ["vgm_backend:%1", _function], [_callback, _arguments]];

true
