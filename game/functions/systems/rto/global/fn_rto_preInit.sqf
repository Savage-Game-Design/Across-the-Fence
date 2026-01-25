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
