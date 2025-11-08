/*
    File: fn_posIndicators_create.sqf
    Author:
    Date: 2025-11-06
    Last Update: 2025-11-08
    Public: No

    Description:
        Creates a new 3D icon at the given locaton.

        Supported indicator keys:
            expires - When the indicator expires, as server time [NUMBER]
            position - Position of marker as 2D or AGL [ARRAY]
            texture - Texture to show [STRING]
            color - Color of the texture and text (RGBA) [ARRAY]
            size - Height of the texture, width is automatic [NUMBER]
            text - Text to show [STRING]

    Parameter(s):
        _indicator - Hashmap with details of the indicator [Hashmap]

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_indicator"];

if !("id" in _indicator) then {
    _indicator set ["id", vgm_c_posIndicators_counter];
    vgm_c_posIndicators_counter = vgm_c_posIndicators_counter + 1;
};

_indicator set ["fadeAlpha", (_indicator get "color" select 3) * 0.4];

vgm_c_posIndicators_indicators set [_indicator get "id", _indicator];
