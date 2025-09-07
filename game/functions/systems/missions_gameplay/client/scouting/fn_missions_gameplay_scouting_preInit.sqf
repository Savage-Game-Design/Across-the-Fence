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
