/*
    File: fn_respawn_onPlayerKilled.sqf
    Author: Savage Game Design, Xorberax
    Public: No

    Description:
        Handles the player killed behavior.
        Saves loadout, stores death position, and drops rucksack at death
        location as a lootable ground container.

    Parameter(s):
        _oldUnit [OBJECT]
        _killer [OBJECT]
        _respawnType [NUMBER]
        _respawnDelay [NUMBER]

    Returns:
        NONE

    Example(s):
        See `CfgRespawnTemplates/vgm_respawn`.
*/

params ["_oldUnit", "_killer", "_respawnType", "_respawnDelay"];

// Store death position for respawn location logic
private _deathPos = getPosATL _oldUnit;
_oldUnit setVariable ["vgm_respawn_deathPos", _deathPos];

// Save full loadout (includes backpack — will be stripped on respawn)
_oldUnit setVariable ["vgm_respawn_loadout", getUnitLoadout _oldUnit];

// Drop rucksack at death position as a lootable ground backpack
if (backpack _oldUnit != "") then {
    private _backpackClass = backpack _oldUnit;
    private _pack = unitBackpack _oldUnit;

    // Capture all cargo before the unit is cleaned up
    private _itemCargo = getItemCargo _pack;
    private _magCargo = getMagazineCargo _pack;
    private _weaponCargo = getWeaponCargo _pack;

    // Create backpack on the ground
    private _ground = createVehicle [_backpackClass, _deathPos, [], 0, "CAN_COLLIDE"];
    _ground setPosATL _deathPos;

    // Restore items into the ground backpack
    for "_i" from 0 to (count (_itemCargo#0) - 1) do {
        _ground addItemCargoGlobal [(_itemCargo#0)#_i, (_itemCargo#1)#_i];
    };
    for "_i" from 0 to (count (_magCargo#0) - 1) do {
        _ground addMagazineCargoGlobal [(_magCargo#0)#_i, (_magCargo#1)#_i];
    };
    for "_i" from 0 to (count (_weaponCargo#0) - 1) do {
        _ground addWeaponCargoGlobal [(_weaponCargo#0)#_i, (_weaponCargo#1)#_i];
    };

    format ["Rucksack dropped at death position: %1 (%2)", _deathPos, _backpackClass] call vgm_g_fnc_logInfo;
};

sleep 1;
[0, "BLACK", 3, 1] spawn BIS_fnc_fadeEffect;

["vgm_player_killed", [], [_oldUnit]] call para_g_fnc_event_triggerTargets;
