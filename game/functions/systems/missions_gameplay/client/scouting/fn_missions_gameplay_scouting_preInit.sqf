/*
    File: fn_mission_gameplay_scouting_preInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2025-08-23
    Public: No

    Description:
        client pre init for mission gameplay scouting system.
 */

["scoutingPhotoRangeBonus", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_scouting_photoRangeBonus", _value];
}, 0] call vgm_c_fnc_coefficient_create;

// Vehicle photo intel config
vgm_c_scouting_opforVehicleClasses = [
    "vn_o_wheeled_z157_01", "vn_o_wheeled_z157_02",
    "vn_o_wheeled_z157_04",
    "vn_o_wheeled_z157_mg_01", "vn_o_wheeled_z157_mg_02",
    "vn_o_wheeled_z157_ammo", "vn_o_wheeled_z157_fuel",
    "vn_o_bicycle_01", "vn_o_bicycle_02"
];
vgm_c_scouting_vehiclePhotoCooldown = 120;
