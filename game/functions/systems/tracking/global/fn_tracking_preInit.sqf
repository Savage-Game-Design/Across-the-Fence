/*
    File: fn_tracking_preInit.sqf
    Author:
    Date: 2024-03-08
    Last Update: 2024-03-09
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

vgm_g_tracking_minDistanceBetweenTracks = 25;
vgm_l_tracking_trackingGroups = createHashmap;

vgm_g_tracking_trackRecordDelay = 15;
vgm_g_tracking_playerSpeedPerSecond = 7;
vgm_g_tracking_maxDistanceForSameTrail = vgm_g_tracking_trackRecordDelay * vgm_g_tracking_playerSpeedPerSecond * 1.2;
















