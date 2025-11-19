/*
    File: fnc_statusEffect_set.sqf
    Author: Savage Game Design
    Date: 2023-07-03
    Last Update: 2025-11-19
    Public: Yes

    Description:
        Set status effect reason on an unit.

    Parameter(s):
        _unit - Unit to set the status effect reason on [OBJECT]
        _effect - Status effect name [STRING]
        _reason - Status effect reason [STRING]
        _duration - Duration in seconds the reason should last [NUMBER]

    Returns:
        Nothing

    Example(s):
        [player, "forceWalk", "broken_legs"] call vgm_c_fnc_statusEffect_set
 */

params [
    ["_unit", objNull, [objNull]],
    ["_effect", "", [""]],
    ["_reason", nil, [""]],
    ["_duration", -1, [0]]
];


if (!(_effect in vgm_c_statusEffect_allEffects)) exitWith {
    format ["Invalid status effect, available values: %1", keys vgm_c_statusEffect_allEffects] call vgm_g_fnc_logError;
};

// Effects currently enabled on the player
private _effectsMap = _unit getVariable "vgm_c_statusEffect_currentEffects";
// If an effect's reason is given a duration, this tracks when that reason should be removed.
private _effectsEndTimes = _unit getVariable "vgm_c_statusEffect_endTimes";
// Ordered list of reason end times, allowing us to check only the next one.
private _effectsEndTimesQueue = _unit getVariable "vgm_c_statusEffect_endTimesQueue";

if (isNil "_effectsMap") then {
    format ["Creating current effects map: %1", _unit] call vgm_g_fnc_logDebug;

    _effectsMap = createHashMap;
    _unit setVariable ["vgm_c_statusEffect_currentEffects", _effectsMap];
    _effectsEndTimes = createHashMap;
    _unit setVariable ["vgm_c_statusEffect_endTimes", _effectsEndTimes];
    _effectsEndTimesQueue = [];
    _unit setVariable ["vgm_c_statusEffect_endTimesQueue", _effectsEndTimesQueue];
    // clear all status effects upon respawn
    _unit addEventHandler ["Respawn", {
        params ["_unit"];
        {
            private _effect = _x;
            {[_unit, _effect, _x] call vgm_c_fnc_statusEffect_remove} forEach _y;
        } forEach (_unit getVariable "vgm_c_statusEffect_currentEffects");
    }]
};

format ["Adding status effect reason: %1 | %2 | %3", _effect, _reason, _duration] call vgm_g_fnc_logDebug;

private _reasonList = _effectsMap getOrDefault [_effect, [], true];

private _effectsReasonEndTimes = _effectsEndTimes getOrDefault [_effect, createHashMap, true];
if (_duration > 0) then {
    private _endTime = serverTime + _duration;
    _effectsReasonEndTimes set [_reason, _endTime];
    _effectsEndTimesQueue pushBack [_endTime, [_effect, _reason]];
    _effectsEndTimesQueue sort true;
} else {
    // No duration - remove any existing duration so this lasts indefinitely.
    _effectsReasonEndTimes deleteAt _reason;
};

if (_reason in _reasonList) exitWith {};
_reasonList pushBack _reason;

// status was not in effect but it is now, apply the onChange callback
if (count _reasonList == 1) then {
    format ["Status effect started: %1", _effect] call vgm_g_fnc_logInfo;

    [_unit, true] call (vgm_c_statusEffect_allEffects get _effect);
};

nil
