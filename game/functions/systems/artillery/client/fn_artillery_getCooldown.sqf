/*
    File: fn_artillery_getCooldown.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Calculates dynamic CAS cooldown based on time of day and weather.
        Night and bad weather each add +100% to base cooldown.
        Strobe Marker skill reduces night penalty by 75%.
        Long Antenna skill reduces weather penalty by 75%.

    Parameter(s):
        _base - Base cooldown in seconds [NUMBER]

    Returns:
        Adjusted cooldown [NUMBER]

    Example(s):
        [300] call vgm_c_fnc_artillery_getCooldown
 */

params ["_base"];

private _mult = 1;

// Night penalty: +100% (or +25% with Strobe Marker)
if (daytime <= 6 || daytime >= 18) then {
    _mult = _mult + (if (player getVariable ["vgm_c_skill_strobeMarker", false]) then {0.25} else {1});
};

// Weather penalty: +100% (or +25% with Long Antenna)
if (overcast > 0.7) then {
    _mult = _mult + (if (player getVariable ["vgm_c_skill_longAntenna", false]) then {0.25} else {1});
};

// Quick Relay reduction
private _qrRank = player getVariable ["vgm_c_skill_quickRelay", 0];
private _qrMult = switch (_qrRank) do {
    case 1: { 0.85 };
    case 2: { 0.70 };
    default { 1 };
};

(_base * _mult * _qrMult)
