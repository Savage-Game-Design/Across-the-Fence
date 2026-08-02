/*
    File: fn_skill_passives_maBell.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Unlocks wiretap capability on transmitter towers (Land_vn_ttowersmall_2_f).
        On mission deploy, scans for nearby transmitters and adds a hold action
        to wiretap communications for bonus XP.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_maBell
 */

#define TAP_DURATION 8
#define SCAN_RADIUS 200
#define SCAN_INTERVAL 5

params ["_known"];

player setUnitTrait ["vgm_skill_maBell", _known, true];
player setVariable ["vgm_g_skill_maBell", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_maBell_deployEh") then {
        [vgm_c_skill_maBell_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_maBell_endEh") then {
        [vgm_c_skill_maBell_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_maBell_active = false;
};

vgm_c_skill_maBell_active = false;

// On mission deploy: start scanning for transmitter towers
vgm_c_skill_maBell_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_maBell_active = true;

    [] spawn {
        while {vgm_c_skill_maBell_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            private _towers = player nearObjects ["Land_vn_ttowersmall_2_f", SCAN_RADIUS];
            {
                if (_x getVariable ["vgm_maBell_tapped", false]) then { continue };
                if (_x getVariable ["vgm_maBell_hasAction", false]) then { continue };

                _x setVariable ["vgm_maBell_hasAction", true];

                [
                    _x,
                    localize "STR_VGM_SKILLS_SKILL_MA_BELL_ACTION",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
                    "_this distance _target < 5",
                    "_caller distance _target < 5",
                    {},
                    {},
                    {
                        params ["_target", "_caller"];
                        hint localize "STR_VGM_SKILLS_SKILL_MA_BELL_DONE";
                        _target setVariable ["vgm_maBell_tapped", true, true];
                        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_maBell_wiretap", 2];
                    },
                    {},
                    [],
                    TAP_DURATION,
                    0,
                    true,
                    false
                ] call BIS_fnc_holdActionAdd;
            } forEach _towers;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_maBell_endEh = ["vgm_mission_ended", {
    vgm_c_skill_maBell_active = false;
}] call para_g_fnc_event_subscribe;
