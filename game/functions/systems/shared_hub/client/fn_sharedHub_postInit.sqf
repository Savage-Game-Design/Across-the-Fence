/*
    File: fn_sharedHub_postInit.sqf
    Author: Savage Game Design
    Date: 2023-11-17
    Last Update: 2024-11-16
    Public: No

    Description:
        Shared Hub client postInit.
 */

vgm_sharedHub_hqAreas = [
    vgm_sharedHub_hq_1
] apply {_x call vgm_g_fnc_objectArea};

[] call vgm_c_fnc_sharedHub_enableHub;
