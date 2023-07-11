/*
    File: fnc_statusEffect_set.sqf
    Author: Savage Game Design
    Date: 2023-07-03
    Last Update: 2023-07-12
    Public: Yes

    Description:
        Set status effect reason on an unit.

    Parameter(s):
        _unit - Unit to set the status effect reason on [OBJECT]
        _effect - Status effect name [STRING]
        _reason - Status effect reason [STRING]

    Returns:
        Nothing

    Example(s):
        [player, "forceWalk", "broken_legs"] call vgm_c_fnc_statusEffect_set
 */

params [
    ["_unit", objNull, [objNull]],
    ["_effect", "", [""]],
    ["_reason", [""]]
];


if (!(_effect in vgm_c_statusEffect_allEffects)) exitWith {
    format ["Invalid status effect, available values: %1", keys vgm_c_statusEffect_allEffects] call vgm_g_fnc_logError;
};

private _effectsMap = _unit getVariable "vgm_c_statusEffect_map";
if (isNil "_effectsMap") then {
    _effectsMap = createHashMap;
    _unit setVariable ["vgm_c_statusEffect_map", _effectsMap];
};

format ["Adding status effect reason: %1 | %2", _effect, _reason] call vgm_g_fnc_logInfo;

private _reasonList = _effectsMap getOrDefault [_effect, [], true];

if (_reason in _reasonList) exitWith {};
_reasonList pushBack _reason;

// status was not in effect but it is now, apply the onChange callback
if (count _reasonList == 1) then {
    format ["Status effect started: %1", _effect] call vgm_g_fnc_logInfo;

    [_unit, true] call (vgm_c_statusEffect_allEffects get _effect);
};

nil
