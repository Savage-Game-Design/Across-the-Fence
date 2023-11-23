/*
    File: fn_missions_startDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-11-23
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

[] call vgm_c_fnc_sharedHub_areaLimiterDisable;

// - Fades the player screen to black
vgm_c_missions_fadeEffectScript = [0, "BLACK", 2, 1] spawn BIS_fnc_fadeEffect;
