/*
    File: fn_skill_passives_recon_keenEye.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-23
    Public: No

    Description:
        Adds logic for Recon Tier 2 Keen Eye skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_recon_betterAim
 */

params ["_known"];

if (!_known) exitWith {
    removeUserActionEventHandler ["revealTarget", "Activate", vgm_c_skill_passives_recon_keenEyeEh];
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

    "vgm_skill_recon_keenEye" cutText [_text, "PLAIN DOWN"];
}];

vgm_c_skill_passives_recon_keenEyeEh = _ehId;
