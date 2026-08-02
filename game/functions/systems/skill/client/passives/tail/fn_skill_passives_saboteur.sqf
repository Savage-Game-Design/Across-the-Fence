/*
    File: fn_skill_passives_saboteur.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Saboteur. Same scan pattern as SLAM but uses a
        silent "Sabotage" hold action (8s). Awards 100 XP, reduces
        alertness by -4. If a target already has a SLAM action,
        Saboteur replaces it (higher tier).

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_saboteur
 */

#define SABOTAGE_DURATION 8
#define SCAN_RADIUS 200
#define SCAN_INTERVAL 5

params ["_known"];

player setUnitTrait ["vgm_skill_saboteur", _known, true];
player setVariable ["vgm_g_skill_saboteur", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_saboteur_deployEh") then {
        [vgm_c_skill_saboteur_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_saboteur_endEh") then {
        [vgm_c_skill_saboteur_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_saboteur_active = false;
};

vgm_c_skill_saboteur_active = false;

// On mission deploy: start scanning for site infrastructure
vgm_c_skill_saboteur_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_saboteur_active = true;

    [] spawn {
        private _hvtTypes = [
            "Land_vn_ttowersmall_2_f",
            "Land_vn_bulldozer_01_abandoned_f",
            "vn_o_ammobox_full_06"
        ];

        while {vgm_c_skill_saboteur_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            {
                private _targets = player nearObjects [_x, SCAN_RADIUS];
                {
                    if (_x getVariable ["vgm_saboteur_destroyed", false]) then { continue };
                    if (_x getVariable ["vgm_saboteur_hasAction", false]) then { continue };

                    _x setVariable ["vgm_saboteur_hasAction", true];

                    [
                        _x,
                        localize "STR_VGM_SKILLS_SKILL_SABOTEUR_ACTION",
                        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                        "_this distance _target < 5",
                        "_caller distance _target < 5",
                        {},
                        {},
                        {
                            params ["_target", "_caller"];
                            hint localize "STR_VGM_SKILLS_SKILL_SABOTEUR_DONE";
                            _target setVariable ["vgm_saboteur_destroyed", true, true];
                            _target setVariable ["vgm_slam_destroyed", true, true];
                            [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_saboteur_process", 2];
                        },
                        {},
                        [],
                        SABOTAGE_DURATION,
                        0,
                        true,
                        false
                    ] call BIS_fnc_holdActionAdd;
                } forEach _targets;
            } forEach _hvtTypes;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_saboteur_endEh = ["vgm_mission_ended", {
    vgm_c_skill_saboteur_active = false;
}] call para_g_fnc_event_subscribe;
