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

params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
// HD can rarely fire for non local units, ignore
if (!local _unit) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: Non local unit"] call vgm_g_fnc_logInfo;
    #endif
    nil
};

// RESET DAMAGE ACCUMULATED OVER TIME (BURNED BY NAPALM/W.P. ETC)
// ----
// remove accumulated damage that hasn't caused a wound after a set period (30 seconds)
private _lastAdded = _unit getVariable ["accumulated_lastAddedAt", serverTime];
if ((serverTime - _lastAdded) > ACCUMULATOR_IGNORE_DAMAGE_TIME) then {
    _unit setVariable ["accumulated_damage", [], true];
};

// damage of the unit/hitpoint BEFORE currently processed damage instance
private _currentDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _currentDamage = damage _unit;
} else {
    _currentDamage = _unit getHitIndex _hitIndex;
};
private _hitDamage = _damage - _currentDamage;

if (!isDamageAllowed _unit) exitWith {_currentDamage};

private _downed = lifeState _unit == "INCAPACITATED";
// prevent unit from being killed when downed
// TODO: Should napalm / WP on downed players result in player death?
//       players can drop nape/WP on downed friends to "save" them,
//       which smells meta-abuse-able.
if (_downed) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: downed"] call vgm_g_fnc_logInfo;
    #endif
    _currentDamage
};

// NAPALM / WILLY PETE DAMAGE
// ----
// * not direct hit
// * very small damage values
// * null instigator and null source
// * projectile is empty string
// * can be most hit parts (including 'incapacitated')
//
// NOTE: @Spoffy: largest values from burns are 'hitchest' or 'hitdiaphragm',
// so just using those for testing just now. but *ideally* should cause
// damage to all body parts.
if (
    !_directHit
    && (isNull _instigator || isNull _source)
    && _projectile isEqualTo ""
    && _hitPoint in ["hitchest", "hitdiaphragm"]
) exitWith {
    // NOTE: @Spoffy: Separate script for accumulated damage.
    //                I'd like to refactor projectile/instantaneous the same way.
    // NOTE: @Spoffy: Could also do multiple HandleDamage EH's assigned
    //                to player. Not sure how i feel about that approach.
    [_unit, _hitDamage, _hitPoint] call vgm_c_fnc_medical_handleDamageAccumulation;
    0
};

// validate damage
if (_projectile isEqualTo "" && {isNull _source}) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: Invalid damage type"] call vgm_g_fnc_logInfo;
    format ["(%2) Invalid damage: %1", _hitPoint, diag_frameNo] call vgm_g_fnc_logDebug;
    #endif
    _currentDamage
};

// filter out tiny amounts of damage
private _ignoreThreshold = [0.3, 0.001] select _directHit;
if (_hitDamage < _ignoreThreshold) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: Below threshold damage"] call vgm_g_fnc_logInfo;
    #endif
    _currentDamage
};

// ignore problematic hitpoints for hitpoint handling
// #structural - we do not want to handle it for hits
// incapacitated - some system hitpoint, idk what it exactly does
// hitbody - it's redundant as it depends on hitpelvis, hitabdomen, hitdipaghram and hitchest, has 1000 armor and causes issues
if (_hitPoint in ["#structural", "incapacitated", "hitbody"]) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: Problematic hit point damage"] call vgm_g_fnc_logInfo;
    format ["(%6) Skipped Damage: %1 | %2 | %3 | %4 | %5", _hitPoint, _hitDamage, _projectile, _source, _selection, diag_frameNo] call vgm_g_fnc_logDebug;
    #endif
    _currentDamage
};

// calculate approximated amount of damage the unit received before armor calculations
// currently does not take passthrough into account
private _armor = [_unit, _hitPoint] call vgm_c_fnc_medical_getArmorHitPoint;
private _realDamage = _hitDamage * _armor;

#ifdef DEBUG
["MEDICAL: HANDLE DAMAGE: Valid damage registered"] call vgm_g_fnc_logInfo;
format ["(%7) Damage: %1 | %2 | %3 | %4 | %5 | %6", _hitPoint, _hitDamage, _realDamage, _projectile, _source, _selection, diag_frameNo] call vgm_g_fnc_logDebug;
#endif

// store multiple hits that happen in a single frame and sort them by damage frame later
private _hitsData = _unit getVariable "vgm_medical_hits";
if (isNil "_hitsData") then {
    _hitsData = createHashMap;
    _unit setVariable ["vgm_medical_hits", _hitsData];

    [{
        params ["_unit", "_hitsData", "_source", "_projectile", "_directHit"];
        private _hitsArray = values _hitsData;
        _unit setVariable ["vgm_medical_hits", nil];

        #ifdef DEBUG
        ["DEBUG", format ["(%2) HitsArray: %1", _hitsArray, diag_frameNo]] call vgm_g_fnc_log;
        #endif

        // sort the hits by damage
        _hitsArray sort false;

        // apply damage
        {
            _x params ["_realDamage", "_hitPoint", "_hitDamage"];

            #ifdef DEBUG
            format ["(%4) Applying damage: %1 | %2 | %3", _realDamage, _hitPoint, _hitDamage, diag_frameNo] call vgm_g_fnc_logDebug;
            #endif

            [_unit, _hitDamage, _hitPoint, _source, _projectile, _directHit] call vgm_c_fnc_medical_receiveDamage;

            // hitpoint with most damage is one that (most likely) directly received the hit in case of direct hit
            if (_directHit) exitWith {};
        } forEach _hitsArray;

    }, [_unit, _hitsData, [_source, _instigator] select isNull _source, _projectile, _directHit]] call vgm_g_fnc_execNextFrame;
};

_hitsData set [_hitPoint, [_realDamage, _hitPoint, _hitDamage]];

// damage of these hitpoint controls visuals or engine features like limping sway etc.
// retain the values set by our other functionalities
if (_hitPoint in ["hithead", "hitbody", "hithands", "hitlegs"]) exitWith {
    #ifdef DEBUG
    ["MEDICAL: HANDLE DAMAGE: Visual/engine feature damage"] call vgm_g_fnc_logInfo;
    #endif
    _currentDamage
};

#ifdef DEBUG
["MEDICAL: HANDLE DAMAGE: Unknown/other damage"] call vgm_g_fnc_logInfo;
#endif

0 // prevent engine damage handling for all other hitpoints
