#include "script_component.inc"
/*
    File: fn_medical_injuryEffectsUpdate.sqf
    Author: Savage Game Design
    Date: 2023-09-02
    Last Update: 2023-09-02
    Public: No

    Description:
        Updates unit injury effects.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [player, "head", 0, 2] call vgm_c_fnc_medical_injuryEffectsUpdate;
 */
#define DEBUG

params ["_unit", "_bodyPart", "_previousWoundLevel", "_currentWoundLevel"];

private _bodyPartInjuryEffects = vgm_medical_injuryEffects get _bodyPart;

// apply injury effects sequentially
private _step = [1, -1] select (_previousWoundLevel > _currentWoundLevel);
for "_woundLevel" from (_previousWoundLevel + _step) to _currentWoundLevel step _step do {
    #ifdef DEBUG
        format ["Applying injury effects: %1 | %2 | %3", name _unit, _bodyPart, _woundLevel] call vgm_g_fnc_logDebug;
    #endif

    private _injuryEffects = _bodyPartInjuryEffects get _woundLevel;

    {
        _x params ["_coefficient", "_value"];
        [_unit, _coefficient, "medical", _value] call vgm_c_fnc_coefficient_set;
    } forEach (_injuryEffects get "coefficient");

    {
        _x params ["_statusEffect", "_inEffect"];
        [_unit, _statusEffect, "medical"] call ([vgm_c_fnc_statusEffect_remove, vgm_c_fnc_statusEffect_set] select _inEffect);
    } forEach (_injuryEffects get "statusEffect");

    _unit call (_injuryEffects get "code");
};

nil
