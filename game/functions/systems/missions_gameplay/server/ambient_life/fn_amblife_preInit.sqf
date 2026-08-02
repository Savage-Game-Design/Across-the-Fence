/*
    File: fn_amblife_preInit.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Pre-initialization for the ambient life system.
        Defines classname pools, budget defaults, and tracking hashmaps.
 */

if (!isServer) exitWith {};

// --- Classname Pools ---

vgm_s_amblife_civilianClasses = [
    "vn_c_men_01", "vn_c_men_02", "vn_c_men_03", "vn_c_men_04", "vn_c_men_05",
    "vn_c_men_06", "vn_c_men_07", "vn_c_men_08", "vn_c_men_09", "vn_c_men_10",
    "vn_c_men_11", "vn_c_men_12", "vn_c_men_13", "vn_c_men_14", "vn_c_men_15",
    "vn_c_men_16", "vn_c_men_17", "vn_c_men_18", "vn_c_men_19", "vn_c_men_20"
];

vgm_s_amblife_civVehicleClasses = [
    "vn_c_bicycle_01", "vn_c_bicycle_02",
    "vn_c_wheeled_m151_01", "vn_c_wheeled_m151_02",
    "vn_c_car_01_01", "vn_c_car_02_01", "vn_c_car_03_01", "vn_c_car_04_01"
];

vgm_s_amblife_civBoatClasses = [
    "vn_c_boat_07_01", "vn_c_boat_07_02",
    "vn_c_boat_08_01", "vn_c_boat_08_02"
];

vgm_s_amblife_opforTruckClasses = [
    "vn_o_wheeled_z157_01", "vn_o_wheeled_z157_02",
    "vn_o_wheeled_z157_04",
    "vn_o_wheeled_z157_mg_01", "vn_o_wheeled_z157_mg_02",
    "vn_o_wheeled_z157_ammo", "vn_o_wheeled_z157_fuel"
];

vgm_s_amblife_opforDriverClasses = [
    "vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05"
];

vgm_s_amblife_opforBikeClasses = [
    "vn_o_bicycle_01", "vn_o_bicycle_02"
];

vgm_s_amblife_checkpointBarrierClasses = [
    "Land_vn_barricade_01_4m_f", "Land_vn_razorwire_f"
];

vgm_s_amblife_animalClasses = [
    "Hen_random_F", "Hen_random_F", "Cock_random_F", "Goat_random_F"
];

// --- Budget Defaults (100% = 1 mission active) ---

vgm_s_amblife_budgetFull = createHashMapFromArray [
    ["civilianGroups", 12],
    ["riverBoats", 8],
    ["opforTrucks", 10],
    ["civRoadVehicles", 0],
    ["bicycleCouriers", 6],
    ["bicycleConvoys", 8],
    ["workParties", 4],
    ["checkpoints", 12],
    ["livestockClusters", 10],
    ["wireTaps", 6]
];

// --- Bicycle Mule Config ---
vgm_s_amblife_bikeMuleClasses = [
    "vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04",
    "vn_o_men_nva_05", "vn_o_men_nva_06"
];
vgm_s_amblife_bikeStallKPH = 2;                // Below this speed, hill-assist kicks in
vgm_s_amblife_bikeNaturalMPS = 2.2;            // Natural flat-ground speed (~8 km/h)
vgm_s_amblife_bikeAssistRampRate = 0.4;         // m/s added per tick — ramps up over ~5s
vgm_s_amblife_activeBikes = [];                 // Global array for hill-assist loop

// --- Convoy Config ---
vgm_s_amblife_truckConvoySizeRange = [2, 3];   // Trucks per convoy
vgm_s_amblife_bikeConvoySizeRange = [2, 4];     // Bikes per supply train

// --- Respawn Config ---
vgm_s_amblife_respawnCooldown = 45;       // Seconds between respawn checks
vgm_s_amblife_respawnInitialDelay = 60;   // Seconds before first respawn check

// --- Per-Mission Tracking ---
// missionId -> array of animal agents
vgm_s_amblife_missionAnimals = createHashMap;
// missionId -> array of simple objects (checkpoint barriers)
vgm_s_amblife_missionObjects = createHashMap;
// missionId -> boolean flag for civilian reporting loop
vgm_s_amblife_missionActive = createHashMap;
// missionId -> script handle for respawn monitor
vgm_s_amblife_missionRespawnHandles = createHashMap;
