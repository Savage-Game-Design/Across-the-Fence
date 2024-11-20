/*
    File: fn_missions_startClientsideMonitoring.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2024-11-02
    Public: No

    Description:
        Starts clientside data reporting for the director system.
        Gathers clientside-only data.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_director_startClientsideMonitoring
 */

if (missionNamespace getVariable ["vgm_c_director_monitoring", false]) exitWith {};

vgm_c_director_monitoring = true;
