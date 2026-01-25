/*
    File: fn_rto_preInit.sqf
    Author: Savage Game Design
    Date: 2026-01-04
    Last Update: 2026-01-25
    Public: No

    Description:
        Global pre-init for RTO system
*/

vgm_g_rto_aircraftTypes = createHashMap;

private _aircraftConfigs = "getNumber (_x >> 'disabled') == 0" configClasses (missionConfigFile >> "vgm_radio_operator" >> "aircraft");

{
    private _aircraftConfig = _x;
    private _vehicleConfig = configFile >> "CfgVehicles" >> getText (_aircraftConfig >> "vehicleClass");

    private _displayName = getText (_aircraftConfig >> "displayName");
    if (_displayName isEqualTo "") then {
        _displayName = getText (_vehicleConfig >> "displayName");
    };

    private _aircraftDetails = createHashMapFromArray [
        ["displayName", _displayName],
        ["vehicleType", getText (_aircraftConfig >> "vehicleType")],
        ["vehicleClass", getText (_aircraftConfig >> "vehicleClass")],
        ["vehicleConfig", _vehicleConfig],
        ["arrivalTimeSecs", getNumber (_aircraftConfig >> "arrivalTimeSecs")],
        ["onStationTimeSecs", getNumber (_aircraftConfig >> "onStationTimeSecs")],
        ["illuminationType", getNumber (_aircraftConfig >> "illuminationType")],
        ["strikes", createHashMapFromArray ("true" configClasses (_x >> "strikes") apply {[
            configName _x,
            createHashMapFromArray [
                ["displayName", getText (_x >> "displayName")],
                ["magazines", getArray (_x >> "magazines")],
                ["uses", getNumber (_x >> "uses")]
            ]
        ]})]
    ];

    vgm_g_rto_aircraftTypes set [configName _aircraftConfig, _aircraftDetails];
} forEach _aircraftConfigs;

// TODO - Unify this with extraction radios
vgm_g_rto_radioBackpacks = ["vn_o_pack_t884_01", "vn_o_pack_t884_ish54_01_pl", "vn_o_pack_t884_m1_01_pl", "vn_o_pack_t884_m38_01_pl", "vn_o_pack_t884_ppsh_01_pl", "vn_b_pack_prc77_01_m16_pl", "vn_b_pack_03_m3a1_pl", "vn_b_pack_03_xm177_pl", "vn_b_pack_03_type56_pl", "vn_b_pack_03", "vn_b_pack_prc77_01", "vn_b_pack_trp_04", "vn_b_pack_trp_04_02", "vn_b_pack_03", "vn_b_pack_03_02", "vn_b_pack_lw_06"];
