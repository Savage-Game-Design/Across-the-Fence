#include "\a3\ui_f\hpp\definecommongrids.inc"
/*
    File: fn_watermark.sqf
    Author: Savage Game Design
    Date: 2025-01-17
    Last Update: 2025-01-17
    Public: No

    Description:
        Enable mission version watermark, called via CfgFunctions.
 */

[] spawn {
    waitUntil {!isNull findDisplay 46};

    private _w = GUI_GRID_W * 10;
    private _h = GUI_GRID_H * 1;

    private _ctrlWatermark = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
    _ctrlWatermark ctrlSetFontHeight (_h * 0.8);
    _ctrlWatermark ctrlSetPosition [
        safeZoneX + safeZoneW - _w,
        safeZoneY,
        _w,
        _h
    ];

    _ctrlWatermark ctrlSetBackgroundColor [0,0,0,0];
    _ctrlWatermark ctrlSetTextColor [1,1,1,0.9];

    _ctrlWatermark ctrlSetStructuredText parseText format ["<t align='right'>%1</t>", localize "STR_VGM_MISSION_NAME_VERSION"];

    _ctrlWatermark ctrlCommit 0;

    uiNamespace setVariable ["vgm_watermark", _ctrlWatermark];
};
