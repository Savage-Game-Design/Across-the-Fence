/*
    File: fn_missions_stopClientsideMonitoring.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
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


if (!vgm_c_director_monitoring) exitWith {};

player removeEventHandler ["FiredMan", vgm_c_director_firedHandler];

["vgm_director_sendRecentShotsToServer"] call para_g_fnc_scheduler_remove_job;

vgm_c_director_monitoring = false;
