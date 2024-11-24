#include "script_component.inc"
/*
    File: fn_skill_investigate_setListenMode.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2024-11-23
    Public: No

    Description:
        Sets "Stop, Listen" mode, showing nearby units movement by sound wave visualization.

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
        private _noiseSources = player nearEntities ["CAManBase", 200];

        {
            [
                _x,
                (abs speed _x) call vgm_c_fnc_skill_investigate_getSpeedDrawCoef
            ] call vgm_c_fnc_skill_investigate_queueNoise;
        } forEach (_noiseSources select {group _x != _ignoredGroup});

        _thisArgs set [0, time + PING_TICK];
    };

    if (vgm_c_skill_investigate_intensity < 1) then {
        vgm_c_skill_investigate_intensity = linearConversion [
            _startTime,
            _startTime + FULL_FOCUS_TIME,
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
