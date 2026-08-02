/*
    File: fn_skill_actives_sitrep_display.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Client-side display for Sitrep skill response.
        Shows alertness level, enemy bearing, and estimated count.

    Parameter(s):
        _alertLabel - Alertness label string [STRING]
        _alertness - Raw alertness value [NUMBER]
        _bearing - Bearing to nearest enemy (-1 if none) [NUMBER]
        _count - Enemy count within 1km [NUMBER]

    Returns:
        Nothing

    Example(s):
        ["High", 65, 180, 4] call vgm_c_fnc_skill_actives_sitrep_display
 */

params ["_alertLabel", "_alertness", "_bearing", "_count"];

private _text = format ["--- SITREP ---\nAlertness: %1 (%2/100)", _alertLabel, round _alertness];

if (_count > 0) then {
    private _bearingStr = [_bearing, 3] call CBA_fnc_formatNumber;
    _text = _text + format ["\nNearest enemy bearing: %1°\nEstimated hostiles (1km): %2", _bearingStr, _count];
} else {
    _text = _text + "\nNo enemy contacts within 1km.";
};

hint _text;
