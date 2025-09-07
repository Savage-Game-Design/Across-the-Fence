/*
    File: fn_extension_preInit.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-08-27
    Public: No

    Description:
        Server preInit function for extension system..
 */

if (!isServer) exitWith {};

addMissionEventHandler ["ExtensionCallback", {
    params ["_function", "_result", "_data"];
    (vgm_s_extension_handlers get _function) params ["_handler", "_arguments"];
    [_result, _data, _arguments] call _handler;
}];
