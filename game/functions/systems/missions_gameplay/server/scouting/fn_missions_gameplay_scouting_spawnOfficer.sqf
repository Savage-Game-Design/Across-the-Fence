/*
    File: fn_missions_gameplay_scouting_spawnOfficer.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Randomly spawns a PAVN officer at a site during a scouting mission.
        Players can kill the officer for bonus XP, or capture and extract
        him for even more XP.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_scouting_spawnOfficer
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "scouting") exitWith {};

// 40% chance to spawn an officer
if (random 1 > 0.4) exitWith {
    format ["Scouting Officer: No officer spawned for mission %1 (random chance)", _missionId] call vgm_g_fnc_logInfo;
};

private _targetZone = _mission get "public" get "targetZone";
private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
if (_sites isEqualTo []) exitWith {};

// Prefer encampments, waystations, supply dumps
private _preferredSites = _sites select {
    (_x get "class") in ["encampment", "waystation", "supplyDump"]
};
if (_preferredSites isEqualTo []) then { _preferredSites = _sites };
private _targetSite = selectRandom _preferredSites;
private _sitePos = _targetSite get "pos";

// Spawn officer + 2 guards
private _officerClasses = ["vn_o_men_nva_01", "vn_o_men_nva_15", "vn_o_men_nva_dc_01"];
private _guardClasses = ["vn_o_men_nva_02", "vn_o_men_nva_04", "vn_o_men_nva_05"];

private _grp = createGroup east;
_grp deleteGroupWhenEmpty true;

private _officer = _grp createUnit [selectRandom _officerClasses, _sitePos, [], 3, "NONE"];
_officer setVariable ["vgm_scouting_officer", true, true];

// Officer appearance: field cap, officer vest (pistol holster), TT-33 sidearm, no backpack
removeAllWeapons _officer;
removeBackpack _officer;
_officer addHeadgear "vn_o_cap_01";
_officer addVest "vn_o_vest_07";
_officer addWeapon "vn_tt33";
_officer addMagazine "vn_tt33_mag";
_officer addMagazine "vn_tt33_mag";
_officer addMagazine "vn_tt33_mag";

{ _grp createUnit [_x, _sitePos, [], 10, "NONE"] } forEach _guardClasses;

// Defend the site
_grp setBehaviourStrong "AWARE";
_grp setCombatMode "RED";
private _wp = _grp addWaypoint [_sitePos, 0];
_wp setWaypointType "HOLD";

// SOG Advanced Revive integration — allows players to bandage / pick up / load
private _hdEH = _officer addEventHandler ["HandleDamage", {_this call vn_fnc_revive_handledamage}];
_officer setVariable ["vn_revive_event_handledamage", _hdEH];

// Forcer EH: SOG marks AI incapacitated but doesn't call setUnconscious for AI
_officer addEventHandler ["HandleDamage", {
    params ["_unit"];
    if (_unit getVariable ["vn_revive_incapacitated", false] && {!isPlayer _unit}) then {
        _unit setUnconscious true;
        _unit setCaptive true;
    };
}];

// HandleDamage: go unconscious at 85% cumulative damage.
// Massive single-hit damage (explosives, vehicles) kills outright.
_officer addEventHandler ["HandleDamage", {
    params ["_unit", "", "_damage"];
    if (_unit getVariable ["vgm_scouting_officer_unconscious", false]) exitWith {0};
    if (_damage > 1) exitWith {nil};
    private _currentDamage = damage _unit;
    if (_currentDamage + _damage > 0.85) then {
        _unit setVariable ["vgm_scouting_officer_unconscious", true, true];
        _unit setVariable ["vn_revive_incapacitated", true, true];
        _unit setUnconscious true;
        _unit setCaptive true;
        [_unit] call vn_fnc_revive_actions_local;
        0
    } else {
        nil
    };
}];

// Monitor for SOG revive clearing incapacitated — restore AI state when revived
[_officer] spawn {
    params ["_unit"];
    while {alive _unit} do {
        waitUntil {sleep 1; !alive _unit || _unit getVariable ["vn_revive_incapacitated", false]};
        if (!alive _unit) exitWith {};
        waitUntil {sleep 1; !alive _unit || !(_unit getVariable ["vn_revive_incapacitated", false])};
        if (!alive _unit) exitWith {};
        _unit setUnconscious false;
        _unit setCaptive false;
        _unit setDamage 0.5;
    };
};

// Store references in scouting netmap
private _scoutingData = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
[_scoutingData, "officer", _officer] call para_s_fnc_netmap_set;
[_scoutingData, "officerGroup", _grp] call para_s_fnc_netmap_set;

// Start monitoring
[_missionId, _officer] spawn vgm_s_fnc_missions_gameplay_scouting_monitorOfficer;

format ["Scouting Officer: Spawned at %1 for mission %2", _sitePos, _missionId] call vgm_g_fnc_logInfo;
