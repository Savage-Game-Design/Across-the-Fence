/*
    File: fn_missions_stopClientsideMonitoring.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2024-11-02
    Public: No

    Description:
        Stops the clientside monitoring started with vgm_c_fnc_director_startClientsideMonitoring

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_director_stopClientsideMonitoring
 */


if !(missionNamespace getVariable ["vgm_c_director_monitoring", false]) exitWith {};

vgm_c_director_monitoring = false;
