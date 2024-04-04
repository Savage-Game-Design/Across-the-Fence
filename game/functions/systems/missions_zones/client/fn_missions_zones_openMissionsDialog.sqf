/*
    File: fn_mission_zones_openMissionsDialog.sqf
    Author: Savage Game Design
    Date: 2024-04-04
    Last Update: 2024-04-04
    Public: Yes

    Description:
        Request mission zone data from the server and open missions dialog.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_missions_zones_openMissionsDialog;
 */

["Waiting for server...", "Please wait", false, false] spawn BIS_fnc_guiMessage;

// ask server for list of available zones with modifiers, display opens on data receive
[] remoteExecCall ["vgm_s_fnc_missions_zones_remoteExec_getList", 2];
