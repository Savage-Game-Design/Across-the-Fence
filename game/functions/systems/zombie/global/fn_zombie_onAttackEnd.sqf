#include "..\..\medical\client\script_component.inc"

/*
    File: fn_zombie_onAttackEnd.sqf
    Author: Savage Game Design
    Date: 2025-10-21
    Last Update: 2025-10-29
    Public: No

    Description:
        Deals damage to the intended attack target, if they're still attackable the end of the animation.

    Parameter(s):
        _zombie - Zombie doing the attacking [UNIT]

    Returns:
        Nothing

    Example(s):
        [_zombie] call vgm_g_fnc_zombie_onAttackEnd;
 */

params ["_zombie"];

private _target = _zombie getVariable ["vgm_l_zombie_attackTarget", objNull];

_zombie setVariable ["vgm_l_zombie_attacking", false];
_zombie setVariable ["vgm_l_zombie_attackTarget", objNull];

// Ensure zombie can still attack the target at the end of the animation.
if !([_zombie, _target] call vgm_g_fnc_zombie_canAttackTarget) exitWith {};

private _hitSound = selectRandom (_zombie getVariable "vgm_l_zombie_sounds" get "hit");
[_zombie, _hitSound, 1] call vgm_g_fnc_zombie_makeNoise;

if (isPlayer _target) then {
    private _bodyPartHit = selectRandomWeighted [BODY_PART_HEAD, 1, BODY_PART_ARMS, 5, BODY_PART_TORSO, 2.5, BODY_PART_LEGS, 2.5];
    private _damageLevel = selectRandomWeighted [
        // 80% of the time, do only 1 damage.
        1, 4,
        // 20% of the time, hit harder
        2, 1
    ];

    [_target, _bodyPartHit, _damageLevel] remoteExecCall ["vgm_c_fnc_medical_addWound", _target];
} else {
    _target setDamage (damage _target + 0.35);
};


// TODO - Consider resurrection and infection

_scream = selectRandom RZ_HumanScreamArray;
[_target, _scream] remoteExecCall ["say3D"];

private _zombieDirVec = vectorDir _zombie vectorAdd [0, 0, 0.1];
private _targetVelocity = velocity _target;

[_target, _targetVelocity vectorAdd (_zombieDirVec vectorMultiply 5)] remoteExecCall ["setVelocity", _target];
