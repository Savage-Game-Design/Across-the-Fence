/*
    File: fn_medical_feedbackInit.sqf
    Author: Savage Game Design
    Date: 2023-07-24
    Last Update: 2023-08-18
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

["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];
    if (_state || {_unit != player}) exitWith {};
    -1 call vgm_c_fnc_medical_feedbackBleeding;
}] call para_g_fnc_event_subscribe;

player addEventHandler ["Killed", {
    -1 call vgm_c_fnc_medical_feedbackBleeding;
}];

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
