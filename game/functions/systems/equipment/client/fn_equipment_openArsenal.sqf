/*
    File: fn_equipment_openArsenal.sqf
    Author: Savage Game Design
    Date: 2023-09-16
    Last Update: 2023-11-10
    Public: No

    Description:
        Open whitelisted arsenal, item availability depends on scripted conditions.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_equipment_openArsenal
 */

#define FULL false
#define GLOBAL false
#define ACTION false

private _arsenal = player;

// clear all items{
[_arsenal, [], GLOBAL] call BIS_fnc_removeVirtualWeaponCargo;
[_arsenal, [], GLOBAL] call BIS_fnc_removeVirtualMagazineCargo;
[_arsenal, [], GLOBAL] call BIS_fnc_removeVirtualBackpackCargo;
[_arsenal, [], GLOBAL] call BIS_fnc_removeVirtualItemCargo;

// add available equipment presets to arsenal
{
    if (!call compile (getText (_x >> "condition"))) then {continue};

    [_arsenal, getArray (_x >> "weapons"), GLOBAL, ACTION] call BIS_fnc_addVirtualWeaponCargo;
    [_arsenal, getArray (_x >> "magazines"), GLOBAL, ACTION] call BIS_fnc_addVirtualMagazineCargo;
    [_arsenal, getArray (_x >> "backpacks"), GLOBAL, ACTION] call BIS_fnc_addVirtualBackpackCargo;
    [_arsenal, getArray (_x >> "items"), GLOBAL, ACTION] call BIS_fnc_addVirtualItemCargo;
} forEach ("true" configClasses (missionConfigFile >> "vgm_equipment"));

["Preload"] call BIS_fnc_arsenal;
["Open", [FULL, _arsenal, player]] call BIS_fnc_arsenal;
