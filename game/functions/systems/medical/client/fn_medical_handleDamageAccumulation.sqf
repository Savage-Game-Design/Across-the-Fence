#include "script_component.inc"
/*
    File: fn_medical_handleDamage.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-12-03
    Public: No

    Description:
        Handle unit damage.

    Parameter(s):
        See: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage

    Returns:
        New damage for handled HitPoint [NUMBER]

    Example(s):
        _unit addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];
 */

// napalm / willy pete / general ambient damage
//
// not direct hit, small value, null instigator or null source, "" projectile.
// can be most hit parts
params ["_unit", "_hitDamage", "_hitPoint"];

// for DEBUG
// private _fnc_sum = {
//     params ["_arr"];
//     private _sum = 0;
//     _arr apply {_sum = _sum + _x};
//     _sum;
// };

// private _fnc_mean = {
//     params ["_arr"];
//     private _sum = [_arr] call _fnc_sum;
//     (_sum / (count _arr));
// };


["MEDICAL: HANDLE DAMAGE: Napalm / Fire / WP and stuff"] call vgm_g_fnc_logInfo;

// _unit setVariable ["accumulate_firing", true, true];

private _acc = _unit getVariable ["accumulated_damage", [] ];
private _data = _unit getVariable ["accumulated_data", [] ];

// low value damage, ignore it -- probably ground shake or something
if (_hitDamage < ACCUMULATOR_THRESHOLD_MIN) exitWith {_currentDamage};

_acc pushBack _hitDamage;
_data pushBack (
    createHashMapFromArray [
        ["damage", _hitDamage],
        ["hitPoint", _hitPoint],
        ["projectile", _projectile],
        ["direct", _directHit]
    ]
);
_unit setVariable ["accumulated_damage", _acc, true];
// _unit setVariable ["accumulated_data", _data, true];
_unit setVariable ["accumulated_lastAddedAt", serverTime, true];

private _accDamage = 0;
_acc apply {_accDamage = _accDamage + _x};

// private _msg = format [
//     "MEDICAL: Current damage accumulator: sum=%1 mean=%2 count=%3 max=%4 min=%5",
//     _accDamage,
//     [_acc] call _fnc_mean,
//     count _acc,
//     selectMax _acc,
//     selectMin _acc
// ];

// hintSilent _msg;
// _msg call vgm_g_fnc_logInfo;

if (_accDamage > ACCUMULATOR_THRESHOLD_WOUND) then {
    private _msg = format [
        "MEDICAL: Apply accumulator damage: sum=%1 mean=%2 count=%3 max=%4 min=%5",
        _accDamage,
        [_acc] call _fnc_mean,
        count _acc,
        selectMax _acc,
        selectMin _acc
    ];

    hintSilent _msg;
    _msg call vgm_g_fnc_logInfo;

    // _source is always null (no direct player/vehicle source)
    // _projectile is always "" (fire damage means no actual projectile)
    // _directHit is always false (see above, fire damage, not actual projectiles)
    [_unit, _accDamage, _hitPoint, objNull, "", false] call vgm_c_fnc_medical_receiveDamage;
    _unit setVariable ["accumulated_damage", [], true];
};

nil;