/*
    File: fn_compromisedLz_preInit.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server preInit for the Compromised LZ system. Initializes config
        constants and the tracking hashmap for occupied LZs.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_compromisedLz_preInit;
*/

if (!isServer) exitWith {};

// Base probability an LZ is compromised (25%)
vgm_s_compromisedLz_baseChance = 0.25;

// Maximum additional chance from alertness (at 100 alertness, adds 40%)
vgm_s_compromisedLz_alertnessScaling = 0.40;

// Seconds before extraction helicopter gives up and RTBs
vgm_s_compromisedLz_extractionTimeout = 300;

// Proximity at which NVA detect players (triggers ambush)
vgm_s_compromisedLz_detectionRange = 18;

// Distance from LZ center — if any player exceeds this, ambush triggers
vgm_s_compromisedLz_leavingRange = 25;

// Minimum distance from players for an LZ to be eligible for compromise
vgm_s_compromisedLz_playerSafeRadius = 200;

// Tracking hashmap: key = hashValue of LZ position, value = defender data hashmap
vgm_s_compromisedLz_occupiedLzs = createHashMap;

// Machine gunner classes (RPD) — 50% of defenders
vgm_s_compromisedLz_mgClasses = [
    "vn_o_men_nva_11",
    "vn_o_men_nva_25",
    "vn_o_men_nva_65_11"
];

// Rifleman classes — other 50% of defenders
vgm_s_compromisedLz_rifleClasses = [
    "vn_o_men_nva_02",
    "vn_o_men_nva_04",
    "vn_o_men_nva_05",
    "vn_o_men_nva_06",
    "vn_o_men_nva_49"
];

"VGM: Compromised LZ system preInit complete" call vgm_g_fnc_logInfo;
