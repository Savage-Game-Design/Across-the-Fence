/*
    File: fn_statusEffect_remove.sqf
    Author: Savage Game Design
    Date: 2023-07-03
    Last Update: 2025-11-29
    Public: No

    Description:
        Remove status effect reason on an unit.

    Parameter(s):
        _unit - Unit to remove the status effect reason from [OBJECT]
        _effect - Status effect name [STRING]
        _reason - Status effect reason [STRING]

    Returns:
        Nothing

    Example(s):
        [player, "forceWalk", "broken_legs"] call vgm_c_fnc_statusEffect_remove
 */

params [
    ["_unit", objNull, [objNull]],
    ["_effect", "", [""]],
    ["_reason", nil, [""]]
];


if (!(_effect in vgm_c_statusEffect_allEffects)) exitWith {
    format ["Invalid status effect, available values: %1", keys vgm_c_statusEffect_allEffects] call vgm_g_fnc_logError;
};

private _effectsMap = _unit getVariable "vgm_c_statusEffect_currentEffects";
if (isNil "_effectsMap") exitWith {};

format ["Removing status effect reason: %1 | %2", _effect, _reason] call vgm_g_fnc_logDebug;

private _reasonList = _effectsMap getOrDefault [_effect, [], true];

private _idx = _reasonList find _reason;

if (_idx == -1) exitWith {};
_reasonList deleteAt _idx;

// Reason is no longer considered "persistent" once it's removed
private _persistentEffectReasons = _unit getVariable "vgm_c_statusEffect_persistentEffectReasons";
_persistentEffectReasons deleteAt [_effect, _reason];

// Prevent a duration-limited effect from attempting to be removed twice.
private _effectsEndTimes = _unit getVariable "vgm_c_statusEffect_endTimes";
_effectsEndTimes getOrDefault [_effect, createHashmap] deleteAt _reason;

// status was in effect but is not anymore, apply the onChange callback
if (count _reasonList == 0) then {
    format ["Status effect stopped: %1", _effect] call vgm_g_fnc_logInfo;

    [_unit, false, false] call (vgm_c_statusEffect_allEffects get _effect);

    _effectsEndTimes deleteAt _effect;
};

nil
