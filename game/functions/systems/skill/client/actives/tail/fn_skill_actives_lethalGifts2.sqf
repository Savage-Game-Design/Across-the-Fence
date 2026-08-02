/*
    File: fn_skill_actives_lethalGifts2.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — Lethal Gifts 2. For 30s, places timed claymores
        behind the player every 15m of movement. Each claymore detonates
        after 40s.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_lethalGifts2
 */

#define DROP_DISTANCE 15

params ["", "_skill"];

["Tail/Lethal Gifts 2 skill activated"] call vgm_g_fnc_logInfo;

private _duration = _skill get "duration";

vgm_c_skill_lethalGifts2_active = true;
vgm_c_skill_lethalGifts2_lastPos = +(getPosATL player);

["skill_lethalGifts2", {
    ["Tail/Lethal Gifts 2 skill exhausted"] call vgm_g_fnc_logInfo;
    vgm_c_skill_lethalGifts2_active = false;
}, _duration, "seconds"] call BIS_fnc_runLater;

[] spawn {
    while {vgm_c_skill_lethalGifts2_active && {alive player}} do {
        sleep 0.5;

        private _currentPos = getPosATL player;
        if (_currentPos distance2D vgm_c_skill_lethalGifts2_lastPos >= DROP_DISTANCE) then {
            [vgm_c_skill_lethalGifts2_lastPos, playerSide] remoteExecCall ["vgm_s_fnc_skill_lethalGifts2_placeClaymore", 2];
            vgm_c_skill_lethalGifts2_lastPos = +_currentPos;
        };
    };
};
