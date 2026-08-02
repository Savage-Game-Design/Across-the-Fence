/*
    File: fn_sites_onObjectDestroyed.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Adds Killed event handlers to high-value target objects at spawned sites.
        When a player destroys an HVT through combat, they receive XP.
        Objects destroyed via SLAM or Saboteur skills are excluded to prevent
        double XP awards.

    Parameter(s):
        _site - The site hashmap from vgm_sites_siteSpawned event [HASHMAP]

    Returns:
        Nothing

    Example(s):
        Called via event subscription in fn_sites_postInit.sqf
 */

if (!isServer) exitWith {};

params ["_site"];

// Classname → XP reward mapping
private _hvtXpMap = createHashMapFromArray [
    // AA Gun
    ["vn_o_nva_65_static_zgu1_01", 50],
    // DSHKM
    ["vn_o_nva_static_dshkm_high_01", 35],
    ["vn_o_nva_65_static_dshkm_high_02", 35],
    // RPD
    ["vn_o_nva_static_rpd_high", 25],
    // Towers
    ["Land_vn_o_tower_02", 30],
    ["Land_vn_o_tower_03", 30],
    ["Land_vn_ttowersmall_2_f", 30],
    // Trucks
    ["vn_o_wheeled_z157_01", 40],
    ["vn_o_wheeled_z157_02", 40],
    // Ammo Caches
    ["vn_o_ammobox_full_06", 20],
    ["vn_o_ammobox_full_08", 20],
    // Radio/Transmitter
    ["Land_vn_o_radio_01", 40]
];

private _objects = _site getOrDefault ["objects", []];

{
    private _object = _x;
    private _type = typeOf _object;
    private _xp = _hvtXpMap getOrDefault [_type, -1];

    if (_xp > 0) then {
        _object addEventHandler ["Killed", {
            params ["_unit", "_killer", "_instigator"];

            // Use instigator if available (e.g. explosive placer), fall back to killer
            private _actualKiller = if (!isNull _instigator) then { _instigator } else { _killer };

            // Must be a west player
            if (!isPlayer _actualKiller || {side _actualKiller != west}) exitWith {};

            // Skip if destroyed by SLAM, Saboteur skill, or satchel charge (they award their own XP)
            if (_unit getVariable ["vgm_slam_destroyed", false]) exitWith {};
            if (_unit getVariable ["vgm_saboteur_destroyed", false]) exitWith {};
            if (_unit getVariable ["vgm_satchel_destroyed", false]) exitWith {};

            // Look up XP from the object's type
            private _type = typeOf _unit;
            private _xpMap = createHashMapFromArray [
                ["vn_o_nva_65_static_zgu1_01", 50],
                ["vn_o_nva_static_dshkm_high_01", 35],
                ["vn_o_nva_65_static_dshkm_high_02", 35],
                ["vn_o_nva_static_rpd_high", 25],
                ["Land_vn_o_tower_02", 30],
                ["Land_vn_o_tower_03", 30],
                ["Land_vn_ttowersmall_2_f", 30],
                ["vn_o_wheeled_z157_01", 40],
                ["vn_o_wheeled_z157_02", 40],
                ["vn_o_ammobox_full_06", 20],
                ["vn_o_ammobox_full_08", 20],
                ["Land_vn_o_radio_01", 40]
            ];

            private _xpAward = _xpMap getOrDefault [_type, 0];
            if (_xpAward <= 0) exitWith {};

            [_actualKiller, _xpAward] call vgm_s_fnc_leveling_addExperience;

            format ["Site HVT: %1 destroyed %2 at %3 (+%4 XP)", name _actualKiller, _type, getPos _unit, _xpAward] call vgm_g_fnc_logInfo;
        }];
    };
} forEach _objects;
