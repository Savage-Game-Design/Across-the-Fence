/*
    File: fnc_statusEffect_get.sqf
    Author: Savage Game Design
    Date: 2023-07-03
    Last Update: 2023-07-12
    Public: Yes

    Description:
        Get status effect state from an unit.

    Parameter(s):
        _unit - Unit to get the status effect from [OBJECT]
        _effect - Status effect name [STRING]

    Returns:
        Status effect state [BOOL]

    Example(s):
        [player, "forceWalk"] call vgm_c_fnc_statusEffect_get
 */

params [
    ["_unit", objNull, [objNull]],
    ["_effect", "", [""]]
];

private _effectMap = _unit getVariable ["vgm_c_statusEffect_currentEffects", createHashMap];

count (_effectMap getOrDefault [_effect, []]) > 0 // return
