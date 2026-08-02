/*
    File: fn_skill_passives_eyesDown.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Eyes Down. Extends trap detection by placing local
        map markers on detected mines, making them visible on the map.
        Uses the same scan-loop pattern as trapDisarm.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_eyesDown
 */

#define SCAN_INTERVAL 1

params ["_known"];

player setUnitTrait ["vgm_skill_eyesDown", _known, true];
player setVariable ["vgm_g_skill_eyesDown", _known, true];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_eyesDown_deployEh") then {
        [vgm_c_skill_eyesDown_deployEh] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_eyesDown_endEh") then {
        [vgm_c_skill_eyesDown_endEh] call para_g_fnc_event_unsubscribe;
    };
    vgm_c_skill_eyesDown_active = false;
};

vgm_c_skill_eyesDown_active = false;
vgm_c_skill_eyesDown_marked = createHashMap;

// On mission deploy: start scanning and marking mines
vgm_c_skill_eyesDown_deployEh = ["vgm_mission_deploy_local", {
    vgm_c_skill_eyesDown_active = true;
    vgm_c_skill_eyesDown_marked = createHashMap;

    [] spawn {
        while {vgm_c_skill_eyesDown_active && {alive player}} do {
            sleep SCAN_INTERVAL;

            // Require trapkit in inventory
            if !("vn_b_item_trapkit" in items player || {"vn_b_item_trapkit_01" in items player}) then { continue };

            private _scanRadius = missionNamespace getVariable ["vgm_c_skill_trapScanRadius", 4];
            private _nearby = player nearObjects ["MineBase", _scanRadius];
            {
                private _key = hashValue _x;
                if (_key in vgm_c_skill_eyesDown_marked) then { continue };

                vgm_c_skill_eyesDown_marked set [_key, true];

                // Create a local map marker at the mine position
                private _markerName = format ["eyesDown_%1", _key];
                private _marker = createMarkerLocal [_markerName, getPosATL _x];
                _marker setMarkerTypeLocal "mil_warning";
                _marker setMarkerColorLocal "ColorRed";
                _marker setMarkerSizeLocal [0.5, 0.5];
                _marker setMarkerTextLocal "Mine";
            } forEach _nearby;
        };
    };
}] call para_g_fnc_event_subscribeLocal;

// Clean up on mission end
vgm_c_skill_eyesDown_endEh = ["vgm_mission_ended", {
    vgm_c_skill_eyesDown_active = false;
    // Delete all mine markers
    {
        private _markerName = format ["eyesDown_%1", _x];
        deleteMarkerLocal _markerName;
    } forEach keys vgm_c_skill_eyesDown_marked;
    vgm_c_skill_eyesDown_marked = createHashMap;
}] call para_g_fnc_event_subscribe;
