/*
    File: fn_zone_marker_hide_info.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Hides the info tooltip about the zone on the map.
    
    Parameter(s):
        None
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [] call para_c_fnc_zone_marker_hide_info;
*/
#include "..\..\..\configs\ui\ui_def_idc.inc"
(findDisplay 12 displayCtrl PARA_RSCDISPLAYMAP_ZONEINFO_IDC) ctrlShow false;
true
