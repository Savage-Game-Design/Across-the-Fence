/*
    File: fn_sites_hints_glint.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Shows glint effect on specified object.

    Parameter(s):
        _object - Effect source [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorTarget] call vgm_c_fnc_sites_hints_glint
 */

// animation speed in frames per second
#define FPS 7
#define ICON_COLOR [1, 1, 1, 0.5]

params ["_object"];

addMissionEventHandler ["Draw3d", {
    _thisArgs params ["_object", "_animTime", "_frame", "_framesNo"];
    private _frameTime = 1 / FPS;

    drawIcon3D [
        getMissionPath format ["assets\glint\vnx_atf_glint_0%1_ca", _frame],
        ICON_COLOR,
        ASLtoATL getPosWorld _object,
        1, 1, 0
    ];

    _animTime = _animTime + diag_deltaTime;
    _frame = ceil ((_animTime / _frameTime) % (_framesNo+1));
    _thisArgs set [1, _animTime];
    _thisArgs set [2, _frame];

    if (_frame > _framesNo) then {
        removeMissionEventHandler ["Draw3d", _thisEventHandler];
    };

}, [_object, 0, 1, 5]];

/*
    Alternative, spawning a day visible light with big flare:
        src_light = createVehicleLocal ["#lightpoint", _pos];
        src_light setLightUseFlare true;
        src_light setLightFlareSize 16;
        src_light setLightFlareMaxDistance 2000;
        src_light setLightDayLight true;

        src_light setLightIntensity 10;

        src_light setLightFlareSize 0.5;
        src_light setLightColor [1, 1, 1];
        src_light setLightAmbient [0,0,0];

        src_light setLightAttenuation  [1, 10, 0, 0, 0.001];
*/
