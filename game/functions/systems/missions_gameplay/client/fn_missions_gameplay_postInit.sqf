/*
    File: fn_missions_gameplay_postInit.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-05-24
    Public: No

    Description:
        Client Postinit for missions_gameplay component.
 */

if (!hasInterface) exitWith {};

player call vgm_c_fnc_missions_gameplay_extraction_addAction;
player addEventHandler ["Respawn", {
    params ["_player"];
    _player call vgm_c_fnc_missions_gameplay_extraction_addAction;
}];

vgm_missions_gameplay_extraction_radioClasses = [
    // props
    "vn_b_prop_prc77_01",
    "vn_b_prop_vrc12",
    "vn_o_prop_t884_01",
    "vn_o_prop_r311_01",
    "vn_o_prop_t102e_01",
    // backpacks
    "vn_b_pack_m41_05",
    "vn_b_pack_trp_04",
    "vn_b_pack_trp_04_02",
    "vn_b_pack_03",
    "vn_b_pack_03_02",
    "vn_b_pack_lw_06",
    "vn_b_pack_prc77_01"
];

["vgm_missions_gameplay_extractionStarted", {
    (_this#0) spawn {
        params ["", "_lzPos"];
        _lzPos set [2, 0];
        // 60s * N of smoke time
        for "_i" from 1 to 2 do {
            private _smoke = createVehicleLocal ["vn_m18_purple_ammo", [0,0,0], [], 0, "NONE"];
            _smoke setPosATL _lzPos;
            waitUntil {isNull _smoke};
        };
    };
}] call para_g_fnc_event_subscribeServer;
