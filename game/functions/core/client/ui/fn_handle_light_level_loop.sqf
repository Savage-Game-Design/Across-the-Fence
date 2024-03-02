/*
    File: fn_handle_light_level_loop.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update: 2024-03-02
    Public: No

    Description:
        Used to set camera aperture based on light level

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_handle_light_level_loop;

*/

terminate (missionNamespace getVariable ["vgm_c_ui_apertureScript", scriptNull]);

vgm_c_ui_apertureScript = [] spawn {
    while {true} do {
        uiSleep 0.5;
        [] call para_c_fnc_set_aperture_based_on_light_level;
    };
};
