/*
    File: fn_netmap_keys.sqf
    Author:
    Date: 2023-06-23
    Last Update: 2023-06-23
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

params ["_code", "_netmap"];

{
    if (_x isEqualTo "_netmap") then { continue };
    call _code;

} forEach _netmap
