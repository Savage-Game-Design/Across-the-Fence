/*
    File: fnc_preInit.sqf
    Author: Savage Game Design
    Date: 2023-07-02
    Last Update: 2023-08-27
    Public: No

    Description:
        Status effect client preInit.
 */

if (!hasInterface) exitWith {};

["forceWalk", {
    params ["_unit", "_inEffect"];
    _unit forceWalk _inEffect;
}] call vgm_c_fnc_statusEffect_create;

["forceJog", {
    params ["_unit", "_inEffect"];
    _unit allowSprint !_inEffect;
}] call vgm_c_fnc_statusEffect_create;

["forceCrawl", {
    params ["_unit", "_inEffect"];

    // TODO look into possiblity to rewrite into animation event handlers
    // from quick resarch it was proven tricky to implement due to player getting stuck in animations
    private _script = _unit getVariable ["vgm_c_statusEffect_crawlScript", scriptNull];
    if (_inEffect && isNull _script) exitWith {
        _script = _unit spawn {
            while {true} do {
                waitUntil {
                    sleep 0.1;
                    stance _this in ["CROUCH", "STAND"]
                };
                systemChat str time;
                _this playAction "PlayerProne";
            };
        };
        _unit setVariable ["vgm_c_statusEffect_crawlScript", _script];
    };

    if (!_inEffect) exitWith {
        terminate _script;
    };
}] call vgm_c_fnc_statusEffect_create;
