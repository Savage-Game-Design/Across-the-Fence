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

// Stance-based track density: min distance between tracks by stance/speed
vgm_g_tracking_minDist_sprint  = 15;  // stance "UP", speed > 5 m/s
vgm_g_tracking_minDist_jog     = 25;  // stance "UP", speed 2-5 m/s
vgm_g_tracking_minDist_walk    = 35;  // stance "UP", speed < 2 m/s
vgm_g_tracking_minDist_crouch  = 50;  // stance "MIDDLE"
vgm_g_tracking_minDist_prone   = 75;  // stance "DOWN"

// Loss-chance roll: weights for each factor that can cause a tracker to lose the trail
vgm_g_tracking_lossFactor_ageMax      = 0.10;  // max 10% from track age
vgm_g_tracking_lossFactor_ageTimeMax  = 600;   // seconds at which age factor maxes out
vgm_g_tracking_lossFactor_distMax     = 0.12;  // max 12% from link distance
vgm_g_tracking_lossFactor_distMin     = 25;    // no penalty below this gap (meters)
vgm_g_tracking_lossFactor_distMaxDist = 100;   // max penalty at this gap (meters)
vgm_g_tracking_lossFactor_nightMax    = 0.17;  // max 17% from darkness
