/*
    File: fn_mortar_preinit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Configuration constants for the 81mm mortar barrage system.
        Defines dispersion, timing, movement thresholds, and state parameters.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        Runs automatically at preInit
*/

// Shell classname (SOG PF 82mm HE round — verify in-game with getArtilleryAmmo)
vgm_s_mortar_shellClassname = "vn_m_type53_he";

// Spawn altitude for shells above impact point
vgm_s_mortar_shellSpawnAltitude = 200;

// Downward velocity for shells (m/s)
vgm_s_mortar_shellDownVelocity = -150;

// State machine tick rate (seconds) — how often processState runs
vgm_s_mortar_tickRate = 3;

// --- SPOTTING state ---
// Initial delay before first spotting round (seconds)
vgm_s_mortar_spotting_initialDelay = [30, 45]; // [min, max]
// Dispersion radius during spotting (meters)
vgm_s_mortar_spotting_dispersion = [150, 200]; // [min, max]
// Time between spotting rounds (seconds)
vgm_s_mortar_spotting_interval = [15, 20]; // [min, max]
// Number of spotting rounds before transitioning to ADJUSTING
vgm_s_mortar_spotting_roundCount = 3;

// --- ADJUSTING state ---
// Dispersion steps (meters) — tightens each step
vgm_s_mortar_adjusting_dispersionSteps = [100, 75, 50, 25];
// Time between adjusting rounds (seconds)
vgm_s_mortar_adjusting_interval = [12, 15]; // [min, max]

// --- FFE (Fire For Effect) state ---
// Dispersion during FFE (meters)
vgm_s_mortar_ffe_dispersion = 50;
// Rounds per volley during FFE
vgm_s_mortar_ffe_roundsPerVolley = [2, 4]; // [min, max]
// Time between volleys (seconds) — ~15 RPM
vgm_s_mortar_ffe_volleyInterval = 4;
// Maximum FFE duration before forced HOLD_FIRE (seconds)
vgm_s_mortar_ffe_maxDuration = 120;

// --- HOLD_FIRE state ---
// Minimum hold fire duration before re-spotting (seconds)
vgm_s_mortar_holdFire_minDuration = [45, 60]; // [min, max]
// How long team must be stationary before spotter can re-acquire (seconds)
vgm_s_mortar_holdFire_stationaryTime = [10, 15]; // [min, max]

// --- Movement detection ---
// Distance team centroid must move to trigger HOLD_FIRE (meters)
vgm_s_mortar_movementThreshold = 150;
