/*
    File: fn_skill_passives_secondSight.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Second Sight passive ability.
        While crouched/prone and stationary for 3+ seconds, enemies within 100m
        are highlighted with faint red icons. Icons disappear when moving.

    Parameter(s):
        _enable - Whether to enable or disable [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_secondSight
 */

params ["_enable"];

if (!_enable) exitWith {
    private _ehId = player getVariable ["vgm_c_skill_secondSight_ehId", -1];
    if (_ehId != -1) then {
        removeMissionEventHandler ["EachFrame", _ehId];
        player setVariable ["vgm_c_skill_secondSight_ehId", nil];
    };

    private _drawEh = player getVariable ["vgm_c_skill_secondSight_drawEhId", -1];
    if (_drawEh != -1) then {
        removeMissionEventHandler ["Draw3D", _drawEh];
        player setVariable ["vgm_c_skill_secondSight_drawEhId", nil];
    };

    player setVariable ["vgm_c_skill_secondSight_stationaryStart", nil];
};

private _ehId = addMissionEventHandler ["EachFrame", {
    private _speed = vectorMagnitude velocity player;
    private _stance = stance player;

    // Must be crouched or prone and not moving
    if (_speed < 0.1 && {_stance in ["CROUCH", "PRONE"]}) then {
        private _stationaryStart = player getVariable ["vgm_c_skill_secondSight_stationaryStart", -1];

        if (_stationaryStart < 0) then {
            player setVariable ["vgm_c_skill_secondSight_stationaryStart", time];
        } else {
            if (time - _stationaryStart >= 3) then {
                // Enable Draw3D if not already active
                if (player getVariable ["vgm_c_skill_secondSight_drawEhId", -1] == -1) then {
                    private _drawEh = addMissionEventHandler ["Draw3D", {
                        private _enemies = (getPosATL player) nearEntities ["CAManBase", 100];
                        {
                            if (side _x != side player && {alive _x}) then {
                                private _pos = getPosATL _x;
                                _pos set [2, 0.3];
                                drawIcon3D [
                                    "\a3\ui_f\data\IGUI\Cfg\Cursors\select_ca.paa",
                                    [1, 0.2, 0.2, 0.35],
                                    _pos,
                                    0.4,
                                    0.4,
                                    0,
                                    "",
                                    0,
                                    0.03
                                ];
                            };
                        } forEach _enemies;
                    }];

                    player setVariable ["vgm_c_skill_secondSight_drawEhId", _drawEh];
                };
            };
        };
    } else {
        // Moving or wrong stance - reset timer and remove draw EH
        player setVariable ["vgm_c_skill_secondSight_stationaryStart", -1];

        private _drawEh = player getVariable ["vgm_c_skill_secondSight_drawEhId", -1];
        if (_drawEh != -1) then {
            removeMissionEventHandler ["Draw3D", _drawEh];
            player setVariable ["vgm_c_skill_secondSight_drawEhId", -1];
        };
    };
}];

player setVariable ["vgm_c_skill_secondSight_ehId", _ehId];
