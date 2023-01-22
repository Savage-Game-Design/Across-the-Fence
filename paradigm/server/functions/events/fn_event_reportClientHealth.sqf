/*
    File: fn_event_reportHealth.sqf
    Author:
    Date: 2022-12-01
    Last Update: 2022-12-01
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

params ["_healthStatus"];

para_s_event_clientHealthInfo set [remoteExecutedOwner, _healthStatus];
