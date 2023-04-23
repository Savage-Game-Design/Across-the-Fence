/*
    File: fn_event_reportHealth.sqf
    Author: Savage Game Design
    Date: 2022-12-01
    Last Update: 2023-01-29
    Public: No

    Description:
        Remote executed by clients to register health check results.

    Parameter(s):
        _healthStatus - Data needed for the healthCheck [ANY]

    Returns:
        Nothing

    Example(s):
        [_checkResults] remoteExec ["para_s_fnc_event_reportHealth", 2];
 */

params ["_healthStatus"];

para_s_event_clientHealthInfo set [remoteExecutedOwner, _healthStatus];
