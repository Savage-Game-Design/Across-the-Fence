/*
    File: fn_skill_passives_rocketman2.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Rocketman 2. When the player fires their last rocket
        (M72 LAW or M20 Super Bazooka), they receive one replacement magazine.
        Max 2 uses per mission.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_rocketman2
 */

#define MAX_USES 2

params ["_known"];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_rocketman2_deployEh") then {
        [vgm_c_skill_rocketman2_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_rocketman2_endEh") then {
        [vgm_c_skill_rocketman2_endEh] call para_g_fnc_event_unsubscribe;
    };
};

// On mission deploy: add Fired EH
vgm_c_skill_rocketman2_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_rocketman2_uses = 0;

    private _eh = player addEventHandler ["Fired", {
        params ["_unit", "_weapon"];

        if (vgm_c_skill_rocketman2_uses >= MAX_USES) exitWith {};

        // Check if it's an AT weapon
        private _atWeapons = ["vn_m72", "vn_m20a1b1_01"];
        if !(_weapon in _atWeapons) exitWith {};

        // Check if player has no more ammo for this weapon
        if (_unit ammo _weapon > 0) exitWith {};
        private _compatMags = compatibleMagazines [_weapon, _weapon];
        if (_compatMags findAny (magazines _unit) > -1) exitWith {};

        // Restore one magazine
        vgm_c_skill_rocketman2_uses = vgm_c_skill_rocketman2_uses + 1;
        private _mag = (_compatMags select 0);
        _unit addMagazine _mag;

        ["Tail/Rocketman 2 skill triggered"] call vgm_g_fnc_logInfo;
        hint localize "STR_VGM_SKILLS_SKILL_ROCKETMAN2_ACTIVATED";
    }];

    player setVariable ["vgm_c_skill_rocketman2_eh", _eh];
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_rocketman2_endEh = ["vgm_mission_ended", {
    if (!isNil {player getVariable "vgm_c_skill_rocketman2_eh"}) then {
        player removeEventHandler ["Fired", player getVariable "vgm_c_skill_rocketman2_eh"];
    };
}] call para_g_fnc_event_subscribe;
