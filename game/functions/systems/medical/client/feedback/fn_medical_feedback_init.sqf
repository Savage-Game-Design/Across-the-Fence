/*
    File: fn_medical_feedbackInit.sqf
    Author: Savage Game Design
    Date: 2023-07-24
    Last Update: 2024-07-05
    Public: No

    Description:
        Initialize medical feedback system.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_feedback_init
 */

["vgm_medical_woundAdded", {
    (_this#0) params ["_unit"];
    if (_unit != player) exitWith {};
    [] call vgm_c_fnc_medical_feedbackHit;
}] call para_g_fnc_event_subscribe;

["blurryVision", {
    params ["_unit", "_value"];
    if (!isPlayer _unit) exitWith {};

    _unit setVariable ["vgm_c_medical_feedback_blurStrength", _value max 0 min 1];

    private _script = missionNamespace getVariable ["vgm_c_medical_feedback_blurScript", scriptNull];
    if (_value > 0 && isNull _script) exitWith {
        vgm_c_medical_feedback_blurScript = _unit spawn {
            vgm_c_medical_feedback_ppBlur ppEffectEnable true;
            while {true} do {
                private _blurStrength = _this getVariable "vgm_c_medical_feedback_blurStrength";
                // blur screen
                vgm_c_medical_feedback_ppBlur ppEffectAdjust [_blurStrength];
                vgm_c_medical_feedback_ppBlur ppEffectCommit 2;
                waitUntil {ppEffectCommitted vgm_c_medical_feedback_ppBlur};
                // unblur screen
                vgm_c_medical_feedback_ppBlur ppEffectAdjust [0];
                vgm_c_medical_feedback_ppBlur ppEffectCommit 3;
                sleep (8 + random 2);
            };
        };
    };

    if (_value <= 0) exitWith {
        vgm_c_medical_feedback_ppBlur ppEffectAdjust [0];
        vgm_c_medical_feedback_ppBlur ppEffectCommit 0;
        vgm_c_medical_feedback_ppBlur ppEffectEnable false;
        terminate vgm_c_medical_feedback_blurScript;
    };

}, 0] call vgm_c_fnc_coefficient_create;

// setup blood effect overlay
call {
    "vgm_medical_blood" cutRsc ["vgm_RscHealthTextures", "PLAIN"];

    // values taken from BIS_fnc_bloodEffect
    private _x = ((0 * safezoneW) + safezoneX) + ((safezoneW - (2.125 * safezoneW * 3/4)) / 2);
    private _y = (-0.0625 * safezoneH) + safezoneY;
    private _w = 2.125 * safezoneW * 3/4;
    private _h = 1.125 * safezoneH;

    private _display = uiNamespace getVariable "vgm_RscHealthTextures";

    private _texUpper = _display displayctrl 1213;
    private _texMiddle = _display displayctrl 1212;
    private _texLower = _display displayctrl 1211;

    _texLower ctrlsetposition [_x, _y, _w, _h];
    _texMiddle ctrlsetposition [_x, _y, _w, _h];
    _texUpper ctrlsetposition [_x, _y, _w, _h];
};

// setup blur post processing effect
call {
    private _effect = -1;
    private _layer = 400; // DynamicBlur base priority/layer is 400
    while {_effect < 0} do {
        _effect = ppEffectCreate ["DynamicBlur", _layer];
        _layer = _layer + 1;
    };

    _effect ppEffectForceInNVG true;
    _effect ppEffectAdjust [0];
    _effect ppEffectCommit 0;
    _effect ppEffectEnable false;

    vgm_c_medical_feedback_ppBlur = _effect;
};

// setup medical status HUD
call {
    "vgm_medical_feedback_hud" cutRsc ["VGM_RscMedicalStatus", "PLAIN", 0, false];
};
