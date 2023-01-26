#include "\a3\3den\ui\resincl.inc"
#include "idcs.inc"
#include "coordinates.inc"

#define VGM_UIFNC(NAME) CONCAT_2(vgm_c_fnc_display,NAME)
#define VGM_UIEH(EVENT,CLASS) [#EVENT, _this] call VGM_UIFNC(CLASS)

#define VGM_FONT "tt2020base_vn"
