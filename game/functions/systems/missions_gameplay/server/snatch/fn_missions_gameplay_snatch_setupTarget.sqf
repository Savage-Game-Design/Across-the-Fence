/*
    File: fn_missions_gameplay_snatch_setupTarget.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Sets up the snatch target officer with a HandleDamage event handler
        that makes the officer go unconscious instead of dying when taking
        sufficient damage. This enables the carry system to pick them up.

    Parameter(s):
        _officer - The PAVN officer unit [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_officer] call vgm_s_fnc_missions_gameplay_snatch_setupTarget;
 */

params ["_officer"];

// SOG Advanced Revive integration — allows players to bandage / pick up / load
private _hdEH = _officer addEventHandler ["HandleDamage", {_this call vn_fnc_revive_handledamage}];
_officer setVariable ["vn_revive_event_handledamage", _hdEH];

// Forcer EH: SOG marks AI incapacitated but doesn't call setUnconscious for AI
_officer addEventHandler ["HandleDamage", {
    params ["_unit"];
    if (_unit getVariable ["vn_revive_incapacitated", false] && {!isPlayer _unit}) then {
        _unit setUnconscious true;
        _unit setCaptive true;
    };
}];

// Damage threshold: go unconscious at 85% cumulative, massive hits kill outright
_officer addEventHandler ["HandleDamage", {
    params ["_unit", "", "_damage"];
    if (_unit getVariable ["vgm_snatch_unconscious", false]) exitWith {0};
    if (_damage > 1) exitWith {nil};
    private _currentDamage = damage _unit;
    if (_currentDamage + _damage > 0.85) then {
        _unit setVariable ["vgm_snatch_unconscious", true, true];
        _unit setVariable ["vn_revive_incapacitated", true, true];
        _unit setUnconscious true;
        _unit setCaptive true;
        [_unit] call vn_fnc_revive_actions_local;
        0
    } else {
        nil
    };
}];

// Monitor for SOG revive clearing incapacitated — restore AI state when revived
[_officer] spawn {
    params ["_unit"];
    while {alive _unit} do {
        waitUntil {sleep 1; !alive _unit || _unit getVariable ["vn_revive_incapacitated", false]};
        if (!alive _unit) exitWith {};
        waitUntil {sleep 1; !alive _unit || !(_unit getVariable ["vn_revive_incapacitated", false])};
        if (!alive _unit) exitWith {};
        _unit setUnconscious false;
        _unit setCaptive false;
        _unit setDamage 0.5;
    };
};
