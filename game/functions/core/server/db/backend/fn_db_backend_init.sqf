/*
    File: fn_db_backend_init.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

"Using Across the Fence Backend API" call vgm_g_fnc_logInfo;

vgm_db_backend_connectScript = [] spawn {
    private _connected = false;
    while {!_connected} do {
        _connected = (["persistence:connect", []] call vgm_s_fnc_extension_call) select 1;
        if (!_connected) then {
            ["Failed to connect to backend, delaying by 10s"] call vgm_g_fnc_logError;
            uiSleep 10
        };
    };
    ["Connected to backend"] call vgm_g_fnc_logInfo;
    missionNamespace setVariable ["vgm_g_dbBackendType", "backend", true];
};

vgm_db_backend_callbackHandlers = createHashMapFromArray [
    ["leveling", createHashMap],
    ["skills", createHashMap]
];

{
    private _schema = _x;
    {
        private _action = _x;
        format ["Adding extension callback for %1:%2", _schema, _action] call vgm_g_fnc_logInfo;

        [format ["%1:%2", _schema, _action], {
            params ["_resultStr", "_data", "_args"];
            _data params ["_requestId", "_data"];
            _args params ["_schema"];

            if (_resultStr == "empty") then {
                format ["Empty data for %2 request: %1", _requestId, _schema] call vgm_g_fnc_logWarning;
                _data = createHashMap;
            };

            (vgm_db_backend_callbackHandlers get _schema deleteAt _requestId) params ["_handler", "_arguments"];
            [_data, _arguments] call _handler;

        }, [_schema]] call vgm_s_fnc_extension_setHandler;
    } forEach ["get", "set"];
} forEach keys vgm_db_backend_callbackHandlers;
