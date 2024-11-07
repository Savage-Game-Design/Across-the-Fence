/*
    File: fn_artillery_menu.sqf
    Author: Savage Game Design
    Date: 2024-11-09
    Last Update: 2024-11-09
    Public: No

    Description:
        Opens the artillery menu, and installs VGM specific event handlers.

    Parameter(s):
        Identical to vn_fnc_artillery_menu - parameters are passed through.

    Returns:
        Same as vn_fnc_artillery_menu

    Example(s):
        ["init"] call vgm_c_fnc_artillery_menu;
 */

[] spawn {
    private _artilleryDisplay = displayNull;
    waitUntil {
        _artilleryDisplay = uiNamespace getVariable ["vn_artillery_display", displayNull];
        !isNull _artilleryDisplay
    };

    ["vgm_artillery_displayOpened", [_artilleryDisplay]] call para_g_fnc_event_triggerLocal;
};

_this call vn_fnc_artillery_menu
