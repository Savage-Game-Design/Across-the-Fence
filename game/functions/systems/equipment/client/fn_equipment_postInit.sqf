/*
    File: fn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-09-16
    Last Update: 2024-11-16
    Public: No

    Description:
        Client postInit function for equipment system.
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_whitelistedarsenal" isNotEqualTo []) then {
    "S.O.G. Whitelisted Arsenal module detected in the mission. VGM Equipment will NOT function corectly!" call vgm_g_fnc_logError;
};

vgm_equipment_arsenals = entities "" select {_x getVariable ["vgm_equipment_arsenal", false]};

{
    _x addAction [
        "Open Arsenal",
        {call vgm_c_fnc_equipment_openArsenal},
        nil,
        1.5,
        false,
        true,
        "",
        "true",
        7
    ]
} forEach vgm_equipment_arsenals;

[] call vgm_c_fnc_equipment_arsenalInit;

// give player basic gear from config
private _cfgEquipment = missionConfigFile >> "vgm_equipment";
player addUniform getText (_cfgEquipment >> "startingUniform");
{player linkItem _x} forEach getArray (_cfgEquipment >> "startingItems");
// binocular
player addWeapon (getArray (_cfgEquipment >> "startingBinocular")#0);
player addBinocularItem (getArray (_cfgEquipment >> "startingBinocular")#1);
