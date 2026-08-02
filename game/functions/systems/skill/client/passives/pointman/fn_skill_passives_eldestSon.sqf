/*
    File: fn_skill_passives_eldestSon.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Enables encountering ammo dumps where booby-trapped ammo can be
        planted for bonus XP. On mission deploy, scans for nearby ammo boxes
        (vn_o_ammobox_full_06) and adds a hold action to plant booby-trapped ammo.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_eldestSon
 */

#define PLANT_DURATION 5
#define SCAN_RADIUS 200
#define SCAN_INTERVAL 5

params ["_known"];

player setUnitTrait ["vgm_skill_eldestSon", _known, true];
player setVariable ["vgm_g_skill_eldestSon", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_eldestSon_deployEh") then {
        [vgm_c_skill_eldestSon_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_eldestSon_endEh") then {
        [vgm_c_skill_eldestSon_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_eldestSon_active = false;
};

vgm_c_skill_eldestSon_active = false;

// On mission deploy: start scanning for ammo boxes
vgm_c_skill_eldestSon_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_eldestSon_active = true;

    [] spawn {
        while {vgm_c_skill_eldestSon_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            private _boxes = player nearObjects ["vn_o_ammobox_full_06", SCAN_RADIUS];
            {
                if (_x getVariable ["vgm_eldestSon_trapped", false]) then { continue };
                if (_x getVariable ["vgm_eldestSon_hasAction", false]) then { continue };

                _x setVariable ["vgm_eldestSon_hasAction", true];

                [
                    _x,
                    localize "STR_VGM_SKILLS_SKILL_ELDEST_SON_ACTION",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                    "_this distance _target < 3",
                    "_caller distance _target < 3",
                    {},
                    {},
                    {
                        params ["_target", "_caller"];
                        hint localize "STR_VGM_SKILLS_SKILL_ELDEST_SON_DONE";
                        _target setVariable ["vgm_eldestSon_trapped", true, true];
                        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_eldestSon_plantBoobyTrap", 2];
                    },
                    {},
                    [],
                    PLANT_DURATION,
                    0,
                    true,
                    false
                ] call BIS_fnc_holdActionAdd;
            } forEach _boxes;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_eldestSon_endEh = ["vgm_mission_ended", {
    vgm_c_skill_eldestSon_active = false;
}] call para_g_fnc_event_subscribe;
