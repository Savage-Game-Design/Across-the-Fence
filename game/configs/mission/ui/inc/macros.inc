/*
    File: macros.inc
    Author: Savage Game Design
    Date: 2023-01-31
    Last Update:
    Public: Yes

    Description:
        Contains all macros used by the UI system.
 */
// Include Eden macros
#include "\a3\3den\ui\resincl.inc"
#define CT_CONTROLS_TABLE 19 // Not defined by Arma

// Include all other macros
#include "idcs.inc"
#include "coordinates.inc"

// Gets the associated sqf function of a display.
// e.g `VGM_UIFNC(Example)` will expand to `vgm_c_fnc_displayExample`
#define VGM_UIFNC(NAME) CONCAT_2(vgm_c_fnc_display,NAME)
// Call the function of the display with the given event and event arguments,
// see https://community.bistudio.com/wiki/User_Interface_Event_Handlers
// e.g. `VGM_UIEH(onLoad,Example)` will expand to
// `["onLoad", _this] call VGM_UIFNC(Example)`
#define VGM_UIEH(EVENT,CLASS) [#EVENT, _this] call VGM_UIFNC(CLASS)

// Default text font, monospaced typewriter-style from SOG:PF
#define VGM_FONT "tt2020base_vn"

#define ADD_Y(DELTA) __EVAL([DELTA] call _fnc_add_y)
