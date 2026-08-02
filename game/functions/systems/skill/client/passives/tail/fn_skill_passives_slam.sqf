/*
    File: fn_skill_passives_slam.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — SLAM. Scans for high-value enemy infrastructure
        (towers, bulldozers, ammo caches) within 200m and adds a hold
        action to plant demolition charges and destroy them for bonus XP.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_slam
 */

#define PLANT_DURATION 6
#define SCAN_RADIUS 200
#define SCAN_INTERVAL 5

params ["_known"];

player setUnitTrait ["vgm_skill_slam", _known, true];
player setVariable ["vgm_g_skill_slam", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_slam_deployEh") then {
        [vgm_c_skill_slam_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_slam_endEh") then {
        [vgm_c_skill_slam_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_slam_active = false;
};

vgm_c_skill_slam_active = false;

// On mission deploy: start scanning for site infrastructure
vgm_c_skill_slam_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_slam_active = true;

    [] spawn {
        private _hvtTypes = [
            "Land_vn_ttowersmall_2_f",
            "Land_vn_bulldozer_01_abandoned_f",
            "vn_o_ammobox_full_06"
        ];

        while {vgm_c_skill_slam_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            {
                private _targets = player nearObjects [_x, SCAN_RADIUS];
                {
                    if (_x getVariable ["vgm_slam_destroyed", false]) then { continue };
                    if (_x getVariable ["vgm_slam_hasAction", false]) then { continue };

                    _x setVariable ["vgm_slam_hasAction", true];

                    [
                        _x,
                        localize "STR_VGM_SKILLS_SKILL_SLAM_ACTION",
                        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                        "_this distance _target < 5",
                        "_caller distance _target < 5",
                        {},
                        {},
                        {
                            params ["_target", "_caller"];
                            hint localize "STR_VGM_SKILLS_SKILL_SLAM_DONE";
                            _target setVariable ["vgm_slam_destroyed", true, true];
                            [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_slam_destroyHvt", 2];
                        },
                        {},
                        [],
                        PLANT_DURATION,
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
vgm_c_skill_slam_endEh = ["vgm_mission_ended", {
    vgm_c_skill_slam_active = false;
}] call para_g_fnc_event_subscribe;
