/*
    File: fn_zombie_attack.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Begins a zombie's attack against a specific target.

    Parameter(s):
        _zombie - Unit to use [UNIT]
        _target - Unit to attack [UNIT]

    Returns:
        Nothing

    Example(s):
        [cursorObject, player] call vgm_g_fnc_zombie_attack;
 */

params ["_zombie", "_target"];

_zombie setVariable ["vgm_l_zombie_attacking", true];
_zombie setVariable ["vgm_l_zombie_attackTarget", _target];
_zombie setVariable ["vgm_l_zombie_nextAttackAvailableTime", time + (_zombie getVariable "vgm_l_zombie_attackDelay")];

_zombie setDir (_zombie getDir _target);

_zombie doWatch _target;
// Performs the attack - damage happens in onAttackEnd.
_zombie switchMove "AwopPercMstpSgthWnonDnon_throw";

// TODO - Set up sounds properly
private _attackSound = selectRandom RZ_NormalZombieAttackArray; //selectRandom ([_zombie,"attack"] call RZ_fnc_zombie_getZombieSoundArray);
playSound3D [_attackSound, _zombie, false, getPosASL _zombie, 1, pitch _zombie];
