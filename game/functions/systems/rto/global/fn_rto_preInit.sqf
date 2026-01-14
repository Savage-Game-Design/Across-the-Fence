/*
    File: fn_rto_preInit.sqf
    Author: Savage Game Design
    Date: 2026-01-04
    Last Update: 2026-01-14
    Public: No

    Description:
        Global pre-init for RTO system
*/

vgm_g_rto_aircraftTypes = createHashMap;

private _aircraftConfigs = "getNumber (_x >> 'disabled') == 0" configClasses (missionConfigFile >> "vgm_radio_operator" >> "aircraft");

{
    private _aircraftConfig = _x;

    private _aircraftDetails = createHashMapFromArray [
        ["displayName", getText (_aircraftConfig >> "displayName")],
        ["vehicleType", getText (_aircraftConfig >> "vehicleType")],
        ["vehicleClass", getText (_aircraftConfig >> "vehicleClass")],
        ["vehicleConfig", configFile >> "CfgVehicles" >> getText (_aircraftConfig >> "vehicleClass")],
        ["arrivalTimeSecs", getNumber (_aircraftConfig >> "arrivalTimeSecs")],
        ["onStationTimeSecs", getNumber (_aircraftConfig >> "onStationTimeSecs")],
        ["illuminationType", getNumber (_aircraftConfig >> "illuminationType")],
        ["strikes", createHashMapFromArray ("true" configClasses (_x >> "strikes") apply {[
            configName _x,
            createHashMapFromArray [
                ["magazines", getArray (_x >> "magazines")],
                ["uses", getNumber (_x >> "uses")]
            ]
        ]})]
    ];

    vgm_g_rto_aircraftTypes set [configName _aircraftConfig, _aircraftDetails];
} forEach _aircraftConfigs;
