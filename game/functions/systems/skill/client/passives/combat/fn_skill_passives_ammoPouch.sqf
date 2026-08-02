/*
    File: fn_skill_passives_ammoPouch.sqf
    Author: Savage Game Design
    Date: 2023-09-13
    Last Update: 2025-06-12
    Public: No

    Description:
        Adds logic for Rifleman Tier 2 Overprepared skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_ammoPouch
 */

params ["_known"];

if (!_known) exitWith {
    private _ehId = player getVariable ["vgm_c_skill_passives_ammoPouchEH", -1];
    if (_ehId != -1) then {
        player removeEventHandler ["Fired", _ehId];
    };
};

private _eh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "", "_gunner"];
    if (
        _weapon != primaryWeapon _gunner
        || {_unit ammo _weapon > 0 || {
            private _compatibleMags = compatibleMagazines [primaryWeapon _unit, currentMuzzle _unit];
            _compatibleMags findAny (magazines _unit) > -1
        }}
    ) exitWith {};

    // fire only once per mission — compare stable mission IDs, not full HashMaps
    private _assignments = ["vgm_mission_assignments", createHashMap] call para_g_fnc_netmap_getOrDefault;
    private _currentMissionId = _assignments getOrDefault [getPlayerID _unit, ""];
    private _usedInMission = _unit getVariable ["vgm_c_skill_passives_ammoPouchMission", ""];
    if (_usedInMission isEqualTo _currentMissionId && {_currentMissionId isNotEqualTo ""}) exitWith {};
    _unit setVariable ["vgm_c_skill_passives_ammoPouchMission", _currentMissionId];

    ["Combat/Ammo pouch skill triggered"] call vgm_g_fnc_logInfo;
    hint localize "STR_VGM_SKILLS_SKILL_AMMOPOUCH_ACTIVATED";

    _unit addMagazines [_magazine, 2];
}];

player setVariable [ "vgm_c_skill_passives_ammoPouchEH", _eh];
