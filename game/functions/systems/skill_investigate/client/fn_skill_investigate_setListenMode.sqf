#include "script_component.inc"
/*
    File: fn_skill_investigate_setListenMode.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2026-05-06
    Public: No

    Description:
        Sets "Listen" mode, showing nearby units movement by sound wave visualization.

    Parameter(s):
        _enable - Mode toggle [BOOL]

    Returns:
        Nothing [BOOL]

    Example(s):
        [true] call vgm_c_fnc_skill_investigate_setListenMode
 */

params ["_enable"];

if (_enable) then {
    ["vgm_listen_mode_enabled", []] call para_g_fnc_event_triggerLocal;
} else {
    ["vgm_listen_mode_disabled", []] call para_g_fnc_event_triggerLocal;
};

private _eh = missionNamespace getVariable ["vgm_c_skill_investigate_drawEh", -1];
if (!_enable) exitWith {
    removeMissionEventHandler ["Draw3D", _eh];
    vgm_c_skill_investigate_drawEh = -1;
    vgm_c_skill_investigate_noises = nil;
    vgm_c_skill_investigate_intensity = 0;
};

if (_eh > -1) exitWith {};


vgm_c_skill_investigate_noises = [];
vgm_c_skill_investigate_intensity = 0;
vgm_c_skill_investigate_drawEh = addMissionEventHandler ["Draw3D", {
    _thisArgs params ["_nextPingTime", "_startTime"];

    if (time >= _nextPingTime) then {

        private _ignoredGroup = group player;
        private _rangeMultiplier = player getVariable ["vgm_c_skill_investigate_rangeMultiplier", 1];
        private _noiseSources = player nearEntities ["CAManBase", 200 * _rangeMultiplier];

        {
            [
                _x,
                (abs speed _x) call vgm_c_fnc_skill_investigate_getSpeedDrawCoef,
                nil,
                [_x] call vgm_c_fnc_skill_investigate_getUnitStateWaveColor
            ] call vgm_c_fnc_skill_investigate_queueNoise;
        } forEach (_noiseSources select {group _x != _ignoredGroup});

        _thisArgs set [0, time + PING_TICK];
    };

    if (vgm_c_skill_investigate_intensity < 1) then {
        private _investigateTimeCoef = player getVariable ["vgm_c_skill_investigate_investigateTimeCoef", 1];
        vgm_c_skill_investigate_intensity = linearConversion [
            _startTime,
            _startTime + (FULL_FOCUS_TIME * _investigateTimeCoef),
            time,
            0,
            1,
            true
        ];
    };

    //----- draw sound sources
    vgm_c_skill_investigate_noises = vgm_c_skill_investigate_noises select {
        !(_x call vgm_c_fnc_skill_investigate_drawSoundWaves) // return, discard completed
    };
}, [time, time]];
