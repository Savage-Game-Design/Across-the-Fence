/*
    File: fn_skill_passives_trapDisarm.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — trap detection and disarm. Scans for nearby punji
        mines within 4m, reveals them to the player's side, and adds a
        hold action to disarm each revealed trap. Requires trapkit.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_trapDisarm
 */

#define SCAN_RADIUS 4
#define SCAN_INTERVAL 1
#define DISARM_DURATION 4

params ["_known"];

player setUnitTrait ["vgm_skill_trapDisarm", _known, true];
player setVariable ["vgm_g_skill_trapDisarm", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_trapDisarm_deployEh") then {
        [vgm_c_skill_trapDisarm_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_trapDisarm_endEh") then {
        [vgm_c_skill_trapDisarm_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_trapDisarm_active = false;
};

vgm_c_skill_trapDisarm_active = false;
vgm_c_skill_trapDisarm_revealed = createHashMap;

// On mission deploy: start scanning and adding disarm actions
vgm_c_skill_trapDisarm_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_trapDisarm_active = true;
    vgm_c_skill_trapDisarm_revealed = createHashMap;

    [] spawn {
        while {vgm_c_skill_trapDisarm_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            // Require trapkit in inventory
            if !("vn_b_item_trapkit" in items player) then { continue };

            private _nearby = player nearObjects ["MineBase", missionNamespace getVariable ["vgm_c_skill_trapScanRadius", SCAN_RADIUS]];
            {
                private _key = hashValue _x;
                if (_key in vgm_c_skill_trapDisarm_revealed) then { continue };
                if !(typeOf _x select [0, 14] == "vn_mine_punji_") then { continue };

                // Reveal the mine to the player's side
                playerSide revealMine _x;
                vgm_c_skill_trapDisarm_revealed set [_key, true];

                // Add disarm hold action
                [
                    _x,
                    localize "STR_VGM_SKILLS_SKILL_TRAP_DISARM_ACTION",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                    "_this distance _target < 2 && {alive _this}",
                    "_caller distance _target < 2 && {alive _caller}",
                    {},
                    {},
                    {
                        params ["_target", "_caller"];
                        hint localize "STR_VGM_SKILLS_SKILL_TRAP_DISARM_DONE";
                        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_trapDisarm_process", 2];
                    },
                    {},
                    [],
                    DISARM_DURATION,
                    0,
                    true,
                    false
                ] call BIS_fnc_holdActionAdd;
            } forEach _nearby;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_trapDisarm_endEh = ["vgm_mission_ended", {
    vgm_c_skill_trapDisarm_active = false;
    vgm_c_skill_trapDisarm_revealed = createHashMap;
}] call para_g_fnc_event_subscribe;
