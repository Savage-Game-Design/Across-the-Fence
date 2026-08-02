/*
    File: fn_skill_passives_toepopper.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Toe-popper. The first time the player runs out of
        M14 toe-popper mines during a mission, they receive 6 more.
        One-time use per mission.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_toepopper
 */

#define SCAN_INTERVAL 2
#define MINE_MAG "vn_mine_m14_mag"
#define REPLENISH_COUNT 6

params ["_known"];

player setUnitTrait ["vgm_skill_toepopper", _known, true];
player setVariable ["vgm_g_skill_toepopper", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_toepopper_deployEh") then {
        [vgm_c_skill_toepopper_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_toepopper_endEh") then {
        [vgm_c_skill_toepopper_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_toepopper_active = false;
};

vgm_c_skill_toepopper_active = false;

// On mission deploy: start tracking M14 mine count
vgm_c_skill_toepopper_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_toepopper_active = true;
    private _hadMines = false;
    private _triggered = false;

    [] spawn {
        private _hadMines = false;
        private _triggered = false;

        while {vgm_c_skill_toepopper_active && {alive player} && {!_triggered}} do {
            sleep SCAN_INTERVAL;

            private _mineCount = {_x == MINE_MAG} count magazines player;

            if (_mineCount > 0) then {
                _hadMines = true;
            };

            if (_hadMines && {_mineCount == 0}) then {
                _triggered = true;
                ["Tail/Toepopper skill triggered"] call vgm_g_fnc_logInfo;
                hint localize "STR_VGM_SKILLS_SKILL_TOEPOPPER_ACTIVATED";
                player addMagazines [MINE_MAG, REPLENISH_COUNT];
            };
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_toepopper_endEh = ["vgm_mission_ended", {
    vgm_c_skill_toepopper_active = false;
}] call para_g_fnc_event_subscribe;
