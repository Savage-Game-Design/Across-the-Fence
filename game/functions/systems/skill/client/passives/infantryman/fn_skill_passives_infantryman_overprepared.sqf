/*
    File: fn_skill_passive_infantryman_overprepared.sqf
    Author: Savage Game Design
    Date: 2023-09-13
    Last Update: 2023-09-23
    Public: No

    Description:
        Adds logic for Rifleman Tier 2 Overprepared skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_infantryman_overprepared
 */

params ["_known"];

if (!_known) exitWith {
    player removeEventHandler ["Fired", player getVariable "vgm_c_skill_passives_overpreparedEH"];
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

    // fire only once per mission
    private _usedInMission = _unit getVariable ["vgm_c_skill_passives_overpreparedMission", createHashMap];
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (_usedInMission isEqualTo _currentMission) exitWith {};
    _unit setVariable ["vgm_c_skill_passives_overpreparedMission", _currentMission];

    ["Rifleman/Overprepared skill triggered"] call vgm_g_fnc_logInfo;
    hint localize "STR_VGM_SKILLS_SKILL_RIFLEMAN_OVERPREPARED_ACTIVATED";

    _unit addMagazines [_magazine, 2];
}];

player setVariable [ "vgm_c_skill_passives_overpreparedEH", _eh];
