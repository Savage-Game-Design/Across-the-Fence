/*
    File: fn_statusEffect_remove.sqf
    Author: Savage Game Design
    Date: 2023-07-03
    Last Update: 2023-07-05
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
    ["_reason", [""]]
];


if (!(_effect in vgm_c_statusEffect_map)) exitWith {
    format ["Invalid status effect, available values: %1", keys vgm_c_statusEffect_map] call vgm_g_fnc_logError;
};

private _effectsMap = _unit getVariable "vgm_c_statusEffect_map";
if (isNil "_effectsMap") then {
    _effectsMap = createHashMap;
    _unit setVariable ["vgm_c_statusEffect_map", _effectsMap];
};

format ["Removing status effect reason: %1 | %2", _effect, _reason] call vgm_g_fnc_logInfo;

private _reasonList = _effectsMap getOrDefault [_effect, [], true];

private _idx = _reasonList find _reason;

if (_idx == -1) exitWith {};
_reasonList deleteAt _idx;

// status was in effect but is not anymore, apply the onChange callback
if (count _reasonList == 0) then {
    format ["Status effect stopped: %1", _effect] call vgm_g_fnc_logInfo;

    [_unit, false] call (vgm_c_statusEffect_map get _effect);
};

nil
