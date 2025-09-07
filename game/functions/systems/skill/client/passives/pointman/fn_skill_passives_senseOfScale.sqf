/*
    File: fn_skill_passives_senseOfScale.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-08-23
    Public: No

    Description:
        Enables using the 'reveal target' key to discover distances when known.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_senseOfScale
 */

params ["_known"];

if (!_known) exitWith {
    removeUserActionEventHandler ["revealTarget", "Activate", vgm_c_skill_passives_senseOfScaleEh];
};

private _ehId = addUserActionEventHandler ["revealTarget", "Activate", {
    private _unit = player;
    if (
        currentWeapon _unit != binocular _unit
        || {cameraView != "GUNNER"}
    ) exitWith {};

    private _from = AGLToASL positionCameraToWorld [0, 0, 0];
    private _to = AGLToASL positionCameraToWorld [0, 0, viewDistance];

    private _lookPosASL = lineIntersectsSurfaces [_from, _to, cameraOn]#0#0;
    private _distance = _from vectorDistance _lookPosASL;

    toFixed 0;
    private _text = "";
    if (_distance < 10) then {
        _text = format ["%1m", _distance];
    } else {
        _text = format ["%1m", round (_distance / 10) * 10];
    };

    "vgm_skill_senseOfScale" cutText [_text, "PLAIN DOWN"];
}];

vgm_c_skill_passives_senseOfScaleEh = _ehId;
