/*
    File: fn_skill_actives_lethalGifts.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — Lethal Gifts. For 30s, automatically places M14
        toe-popper mines behind the player every 5m of movement.
        Mines are created server-side and revealed to friendly side.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_lethalGifts
 */

#define DROP_DISTANCE 5

params ["", "_skill"];

["Tail/Lethal Gifts skill activated"] call vgm_g_fnc_logInfo;

private _duration = _skill get "duration";
private _lastPos = getPosATL player;

vgm_c_skill_lethalGifts_active = true;
vgm_c_skill_lethalGifts_lastPos = +_lastPos;

["skill_lethalGifts", {
    ["Tail/Lethal Gifts skill exhausted"] call vgm_g_fnc_logInfo;
    vgm_c_skill_lethalGifts_active = false;
}, _duration, "seconds"] call BIS_fnc_runLater;

[] spawn {
    while {vgm_c_skill_lethalGifts_active && {alive player}} do {
        sleep 0.5;

        private _currentPos = getPosATL player;
        if (_currentPos distance2D vgm_c_skill_lethalGifts_lastPos >= DROP_DISTANCE) then {
            // Place mine at the old position (behind player)
            [vgm_c_skill_lethalGifts_lastPos, playerSide] remoteExecCall ["vgm_s_fnc_skill_lethalGifts_placeMine", 2];
            vgm_c_skill_lethalGifts_lastPos = +_currentPos;
        };
    };
};
