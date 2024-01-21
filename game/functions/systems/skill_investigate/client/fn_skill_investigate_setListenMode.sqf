/*
    File: fn_skill_investigate_setListenMode.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2024-01-21
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [true] call vgm_c_fnc_skill_investigate_setListenMode
 */

#define PING_TICK 3

params ["_enabled"];

private _eh = missionNamespace getVariable ["vgm_c_skill_investigate_drawEh", -1];
if (!_enabled) exitWith {
    removeMissionEventHandler ["Draw3D", _eh];
    vgm_c_skill_investigate_drawEh = -1;
};

if (_eh > -1) exitWith {};

vgm_c_skill_investigate_noises = [];
vgm_c_skill_investigate_drawEh = addMissionEventHandler ["Draw3D", {
    _thisArgs params ["_nextPingTime"];

    if (time >= _nextPingTime) then {

        private _ignoredGroup = group player;
        private _noiseSources = player nearEntities ["CAManBase", 100];

        {
            vgm_c_skill_investigate_noises pushBack [
                time,
                _x,
                [random 360, random 360, random 360]
            ];
        } forEach (_noiseSources select {group _x != _ignoredGroup});

        _thisArgs set [0, time + PING_TICK];
    };

    //----- draw sound sources
    {
        private _completed = _x call fnc_draw;
        if (_completed) then {vgm_c_skill_investigate_noises deleteAt _forEachIndex}
    } forEachReversed vgm_c_skill_investigate_noises;
}, [time]];

#define WAVE_SPEED 45
#define ICON_BASE_SIZE 0.1
#define ICON_BASE_DIST 10
#define ICON_ALPHA 0.4
#define FADE_TIME_COEF 5

#define WAVE1_TIME 0
#define WAVE2_TIME 0.8
#define WAVE3_TIME 1.6

fnc_drawIcon = {
    params ["_target", "_elapsed", ["_rot", 0]];
    private _posASL = getPosASLVisual _target;

    private _iconSize = ICON_BASE_SIZE * ((_elapsed * WAVE_SPEED));
    private _dist = getPosASLVisual player vectorDistance _posASL;
    _iconSize = _iconSize * (ICON_BASE_DIST / _dist); // furher the sound the smaller the wave
    _iconSize = _iconSize * (speed _target call fnc_getSpeedCoef);

    private _fadeStr = _elapsed / FADE_TIME_COEF;

    drawIcon3D [
        getMissionPath "SquiglyCircle_ca.paa",
        [0.9,1,1,ICON_ALPHA] vectorAdd [0,0,0, -_fadeStr],
        ASLToAGL _posASL,
        _iconSize, _iconSize,
        _rot, "", 1, 0.05, "TahomaB"
    ];

    (ICON_ALPHA - _fadeStr) < 0 // return
};

fnc_draw = {
    params ["_startTime", "_object", "_texRotation"];

    private _elapsed = time - _startTime;
    {
        if (_elapsed < _x) then {continue};
        [_object, (_elapsed - _x), _texRotation#_forEachIndex] call fnc_drawIcon // return
    } forEach [WAVE1_TIME, WAVE2_TIME, WAVE3_TIME];
};

fnc_getSpeedCoef = {
    params ["_speed"];

    _progress = linearConversion [0, 18, _speed, 0, 1, true];
    _progress bezierInterpolation [
        [0.0, 0, 0],
        [0.5, 0, 0],
        [0.5, 0, 0],
        [0.8, 0, 0],
        [0.9, 0, 0],
        [0.9, 0, 0],
        [0.9, 0, 0],
        [1.5, 0, 0]
    ] params ["_coef"];

    _coef // return
};

/*
[0.0, 0, 0],
[0.5, 0, 0],
[0.5, 0, 0],
[0.8, 0, 0],
[0.9, 0, 0],
[0.9, 0, 0],
[0.9, 0, 0],
[1.5, 0, 0]
*/
