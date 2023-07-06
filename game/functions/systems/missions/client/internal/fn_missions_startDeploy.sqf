/*
    File: fn_missions_startDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-06-30
    Public: No

    Description:
        Starts the player deploying on their assigned mission.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_missions_startDeploy", _player];
 */

["Beginning mission deploy"] call vgm_g_fnc_logInfo;

// - Fades the player screen to black
