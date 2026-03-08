/*
    File: fn_rto_getTimeModifiersForPlayer.sqf
    Author: Savage Game Design
    Date: 2026-03-08
    Last Update: 2026-03-11
    Public: No

    Description:
        Gets any modifiers currently active for the various aircraft timings (e.g. arrival time, on station time, strike time)

    Parameter(s):
        _unit - Player calling the strike [STRING]

    Returns:
        Various times, in the format: [
            ["arrivalTimeSecs", [["total": NUMBER], ["reasons", [reason1, reason2]]]]
            ["strikeTimeSecs", [["total": NUMBER], ["reasons", [reason1, reason2]]]]
        ] [Array]

    Example(s):
        [player] call vgm_g_fnc_rto_getTimeModifiersForPlayer;
 */

params ["_unit"];

private _template = createHashMapFromArray [["total", 1], ["reasons", []]];
private _arrivalTimeMult = +_template;
private _onStationTimeMult = +_template;
private _refuelTimeMult = +_template;
private _strikeDelaySecs = createHashMapFromArray [["total", 0], ["reasons", []]];

private _modifiers = createHashMapFromArray [
    ["arrivalTimeMult", _arrivalTimeMult],
    ["onStationTimeMult", _onStationTimeMult],
    ["refuelTimeMult", _refuelTimeMult],
    ["strikeDelaySecs", _strikeDelaySecs]
];

private _radioType = [_unit] call vgm_g_fnc_rto_getUsableRadioType;

if (_radioType isEqualTo "HANDHELD") then {
    _arrivalTimeMult set ["total", (_arrivalTimeMult get "total") + 0.5];
    _arrivalTimeMult get "reasons" pushBack "STR_VGM_RTO_REASON_HANDHELD";

    _strikeDelaySecs set ["total", (_strikeDelaySecs get "total") + 20];
    _strikeDelaySecs get "reasons" pushBack "STR_VGM_RTO_REASON_HANDHELD";
};

_modifiers
