/*
    File: fn_skill_actives_stonesThrow.sqf
    Author: Savage Game Design
    Date: 2025-08-18
    Last Update: 2025-08-18
    Public: No

    Description:
        Activates the "Stone's throw" skill

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_stonesThrow
 */

#define THROW_DISTANCE 30
#define SOUND_RADIUS 40

params ["", "_skill"];

["Stone's throw skill activated"] call vgm_g_fnc_logInfo;

private _targetPos = getPosATL player getPos [THROW_DISTANCE, getDir player];

[
    vgm_c_dangerReport_locEventGroup,
    _targetPos,
    SOUND_RADIUS,
    "player_distraction",
    []
] call vgm_g_fnc_locEvents_triggerEvent;

playSound3D ['a3\sounds_f\characters\stances\grenade_throw1.wss', player, false, getPosASL player, 5, 1, 10];

[_targetPos] spawn {
    params ["_targetPos"];
    sleep 1;
    private _sound = selectRandom ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13'];
    playSound3D [format ['a3\sounds_f_exp\environment\sfx\rock_debris\rock_debris_%1.wss', _sound], objNull, false, ATLtoASL _targetPos, 3, 1, SOUND_RADIUS * 2];
};
