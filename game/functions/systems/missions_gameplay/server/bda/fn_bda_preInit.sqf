/*
	File: fn_bda_preInit.sqf
	Author: Atlas
	Date: 2026-03-05
	Last Update: 2026-03-05
	Public: No

	Description:
		Pre-initialization for the BDA (Battle Damage Assessment) ambient
		encounter system. Defines constants, classname pools, and tracking hashmap.
 */

if (!isServer) exitWith {};

// --- Constants ---
vgm_s_bda_zoneRadius = 40;
vgm_s_bda_spawnChance = 0.35;

// --- Classname Pools ---
vgm_s_bda_mineClass = "vn_mine_m14";
vgm_s_bda_truckClasses = [
    "vn_o_wheeled_z157_01", "vn_o_wheeled_z157_02",
    "vn_o_wheeled_z157_04",
    "vn_o_wheeled_z157_mg_01", "vn_o_wheeled_z157_mg_02",
    "vn_o_wheeled_z157_ammo", "vn_o_wheeled_z157_fuel"
];
vgm_s_bda_nvaClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05"];
vgm_s_bda_craterClasses = ["CraterLong", "CraterLong_small"];

// --- Per-Mission Tracking ---
vgm_s_bda_missionData = createHashMap;
