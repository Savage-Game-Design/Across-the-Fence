/*
    File: fn_carry_canCarry.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-11-03
    Public: No

    Description:
        Check if unit can carry the target.

    Parameter(s):
        _unit   - Unit trying to carry [OBJECT]
        _target - Carried unit         [OBJECT]

    Returns:
        Can carry [BOOL]

    Example(s):
        [player, cursorObject] call vgm_c_fnc_carry_doCarry
 */

params ["_unit", "_target"];

// prevent unable to move in combat pace
[_unit, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_set;

_target attachTo [_unit, [0.22,0.7,0]];
_target setDir 180;

[_unit, "AcinPknlMstpSnonWnonDnon_AcinPercMrunSnonWnonDnon"] remoteExec ["switchMove", 0];
[_target, "AinjPfalMstpSnonWrflDnon_carried_Up"] remoteExec ["switchMove", 0];

_unit setVariable ["vgm_carry_target", _target];

["vgm_carry_attach", {
    private _unit = player; // TODO implement custom "runLater" that allows passing args
    _target = _unit getVariable "vgm_carry_target";
    _target attachTo [_unit, [0.2, -0.07, -1.1], "spine3"];
    _target setDir 0;

    [_unit, "AcinPercMstpSrasWrflDnon"] remoteExec ["switchMove", 0];
    [_target, "vn_carried_still"] remoteExec ["switchMove", 0];

    private _action = _unit addAction [
        format ["<t color='#ff0000'>%1</t>", localize "STR_VN_REVIVE_ACTION_DROP"],
        {
            params ["_unit"];
            _unit playActionNow "released";
            ["vgm_carry_detach", {
                private _unit = player; // TODO implement custom "runLater" that allows passing args
                private _target = _unit getVariable ["vgm_carry_target", objNull];

                detach _target;
                [_target, "UnconsciousReviveDefault"] remoteExec ["switchMove", 0];

                [_unit, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_remove;
            }, 4] call BIS_fnc_runLater;
        },
        nil,
        50,
        true,
        true,
        "",
        "!isNull (_this getVariable ['vgm_carry_target', objNull])",
        -1
    ];

}, 9] call BIS_fnc_runLater;


