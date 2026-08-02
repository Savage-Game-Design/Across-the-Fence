#include "script_component.inc"
/*
    File: fn_sites_hints_glint.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2024-12-16
    Public: Yes

    Description:
        Shows glint effect on specified object.

    Parameter(s):
        _object - Effect source [OBJECT]
        _iterations - How many times to loop the effect [NUMBER, defaults to 1]
        _color - RGBA color array [ARRAY, defaults to [1, 1, 1, 0.5]]

    Returns:
        Nothing

    Example(s):
        [cursorTarget] call vgm_c_fnc_sites_hints_glint
 */

params [
    ["_object", objNull, [objNull]],
    ["_iterations", 1],
    ["_color", [1, 1, 1, 0.5], [[]]]
];

addMissionEventHandler ["EachFrame", {
    _thisArgs params ["_object", "_animTime", "_frame", "_curIteration", "_iterations", "_color"];
    private _frameTime = 1 / GLINT_FPS;

    if (_animTime > 0) then {
        drawIcon3D [
            vgm_sites_hints_glintTextures select _frame,
            _color,
            ASLtoATL getPosWorld _object,
            1, 1, 0
        ];
    };

    _animTime = _animTime + diag_deltaTime;
    _frame = ceil ((_animTime / _frameTime) % (GLINT_FRAMES+1));

    if (_frame > GLINT_FRAMES) then {
        if (_curIteration >= _iterations) exitWith {
            removeMissionEventHandler [_thisEvent, _thisEventHandler];
        };
        _thisArgs set [3, _curIteration + 1];
        _animTime = -GLINT_ITER_DELAY;
    };

    _thisArgs set [1, _animTime];
    _thisArgs set [2, _frame];

}, [_object, 0, 1, 1, _iterations, _color]];

["vgm_sites_hints_glint", [_object]] call para_g_fnc_event_triggerLocal;
