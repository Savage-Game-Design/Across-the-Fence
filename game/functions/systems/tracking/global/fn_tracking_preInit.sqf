/*
    File: fn_tracking_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-05-03
    Public: No

    Description:
        Tracking system preInit

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

vgm_g_tracking_minDistanceBetweenTracks = 25;
vgm_l_tracking_trackingGroups = createHashmap;

vgm_g_tracking_trackRecordDelay = 15;
// Measured in Arma, this is the max distance a player can move in 1 second while sprinting (vanilla).
vgm_g_tracking_playerSpeedPerSecond = 7;
vgm_g_tracking_maxDistanceForSameTrail = vgm_g_tracking_trackRecordDelay * vgm_g_tracking_playerSpeedPerSecond * 1.2;

vgm_g_tracking_minimumTrackRetentionTimeSeconds = 10 * 60;
vgm_g_tracking_maxEntriesPerUnit = vgm_g_tracking_minimumTrackRetentionTimeSeconds / vgm_g_tracking_trackRecordDelay;
