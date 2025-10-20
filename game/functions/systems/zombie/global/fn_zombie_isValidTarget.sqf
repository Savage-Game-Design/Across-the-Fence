/*
    File: fn_zombie_isValidTarget.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Is the given target a valid target for the zombie to engage?

    Parameter(s):
        _zombie - Unit to use [UNIT]
        _possibleTarget - Target to check [UNIT]

    Returns:
        Nothing

    Example(s):
        [_zombie, allPlayers # 0] call vgm_g_fnc_zombie_isValidTarget;
 */

params ["_zombie", "_possibleTarget"];

private _aggroRange = _zombie getVariable "vgm_l_zombie_aggroRange";

// Start with `alive` check as it filters out objNull early
alive _possibleTarget && {
       (_possibleTarget distance _zombie < _aggroRange)
    && _possibleTarget getUnitTrait "camouflageCoef" > 0
    && !(_possibleTarget getVariable ["vgm_g_zombie_isZombie", false])
    && { [_zombie, _possibleTarget, _aggroRange] call vgm_g_fnc_zombie_canSee }
}
