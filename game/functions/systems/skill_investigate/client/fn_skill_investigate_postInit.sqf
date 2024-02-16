/*
    File: fn_skill_investigate_postInit.sqf
    Author: Savage Game Design
    Date: 2024-01-17
    Last Update: 2024-02-12
    Public: No

    Description:
        Post init for Skill Investigate component.
 */

// setup desaturation
call {
    private _effect = -1;
    private _layer = 1500; // ColorCorrections base priority/layer is 1500
    while {_effect < 0} do {
        _effect = ppEffectCreate ["ColorCorrections", _layer];
        _layer = _layer + 1;
    };

    _effect ppEffectForceInNVG true;
    // create effect with default values
    // https://community.bistudio.com/wiki/Post_Process_Effects#ColorCorrections
    _effect ppEffectAdjust [
        1,
        1,
        0,
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0.299, 0.587, 0.114, 0],
        [-1, -1, 0, 0, 0, 0, 0]
    ];
    _effect ppEffectCommit 0;
    _effect ppEffectEnable false;

    vgm_c_skill_investigate_ppDesaturate = _effect;
};

player call vgm_c_fnc_skill_investigate_addAction;
player addEventHandler ["Respawn", {(_this#0) call vgm_c_fnc_skill_investigate_addAction}];

[true, "vn_sam_dynamic_audio_play", {
    if (missionNamespace getVariable ["vgm_c_skill_investigate_drawEh", -1] == -1) exitWith {};
    params ["_unit", "", "_voiceType"];

    [
        _unit,
        _voiceType call vgm_c_fnc_skill_investigate_getVoiceDrawCoef,
        _unit selectionPosition "head"
    ] call vgm_c_fnc_skill_investigate_queueNoise;

}] call BIS_fnc_addScriptedEventHandler;
