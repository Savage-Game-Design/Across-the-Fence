/*
    File: fn_director_addAlertness.sqf
    Author: Savage Game Design
    Date: 2025-08-30
    Last Update: 2025-08-30
    Public: No

    Description:
        Adds alertness to the current mission

    Parameter(s):
        _director - Director to add alertness to [HASHMAP]
        _alertnessGain - Alertness to add [NUMBER]

    Returns:
        New total alertness [NUMBER]

    Example(s):
        [10] call vgm_s_fnc_director_addAlertness;
 */

params ["_director", "_alertnessGain"];

// Wire tap gain modifier: halves positive alertness gains while active
private _wireTapMod = _director getOrDefault ["wireTapGainModifier", 1];
private _wireTapExp = _director getOrDefault ["wireTapGainModifierExpiry", 0];
if (_wireTapMod < 1 && {serverTime < _wireTapExp}) then {
	if (_alertnessGain > 0) then {
		_alertnessGain = _alertnessGain * _wireTapMod;
	};
} else {
	_director deleteAt "wireTapGainModifier";
	_director deleteAt "wireTapGainModifierExpiry";
};

private _oldAlertness = _director get "alertness";
private _newAlertness = (_oldAlertness + _alertnessGain) min vgm_s_director_max_alertness max 0;

_director set ["alertness", _newAlertness];

// Reset decay cooldown on positive alertness gains
if (_alertnessGain > 0) then {
    _director set ["lastAlertnessEventTime", serverTime];
};

// Voice lines: combat radio chatter on threshold crossings (RTO required)
if (_alertnessGain > 0) then {
    // Prairie Fire at 70+ (priority - bypasses category cooldown)
    if (_oldAlertness < 70 && {_newAlertness >= 70}) then {
        ["combat", "prairie_fire", true, objNull, true] call vgm_s_fnc_voicelines_play;
    } else {
        // Heavy contact at 40+
        if (_oldAlertness < 40 && {_newAlertness >= 40}) then {
            ["combat", "heavy_contact", true] call vgm_s_fnc_voicelines_play;
        };
    };
};

_newAlertness
