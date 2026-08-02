/*
    File: fn_skill_passives_trapDetect.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Pointman passive — trap detection. Scans for nearby punji mines
        within 4m and reveals them to the player's side when the player
        has a trapkit equipped. Uses the same scan-loop pattern as Eldest Son.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_trapDetect
 */

#define SCAN_RADIUS 4
#define SCAN_INTERVAL 1

params ["_known"];

player setUnitTrait ["vgm_skill_trapDetect", _known, true];
player setVariable ["vgm_g_skill_trapDetect", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_trapDetect_deployEh") then {
        [vgm_c_skill_trapDetect_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_trapDetect_endEh") then {
        [vgm_c_skill_trapDetect_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_trapDetect_active = false;
};

vgm_c_skill_trapDetect_active = false;
vgm_c_skill_trapDetect_revealed = createHashMap;

// On mission deploy: start scanning for punji traps
vgm_c_skill_trapDetect_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_trapDetect_active = true;
    vgm_c_skill_trapDetect_revealed = createHashMap;

    [] spawn {
        while {vgm_c_skill_trapDetect_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            // Require trapkit in inventory
            if !("vn_b_item_trapkit" in items player) then { continue };

            private _nearby = player nearObjects ["MineBase", missionNamespace getVariable ["vgm_c_skill_trapScanRadius", SCAN_RADIUS]];
            {
                private _key = hashValue _x;
                if (_key in vgm_c_skill_trapDetect_revealed) then { continue };
                if !(typeOf _x select [0, 14] == "vn_mine_punji_") then { continue };

                // Reveal the mine to the player's side so it becomes visible on HUD
                playerSide revealMine _x;
                vgm_c_skill_trapDetect_revealed set [_key, true];
            } forEach _nearby;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_trapDetect_endEh = ["vgm_mission_ended", {
    vgm_c_skill_trapDetect_active = false;
    vgm_c_skill_trapDetect_revealed = createHashMap;
}] call para_g_fnc_event_subscribe;
