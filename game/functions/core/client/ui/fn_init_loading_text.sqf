/*
    File: fn_init_loading_text.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update:
    Public: /shrug

    Description:
        call text loading screen stuff.

    Parameter(s):
        N/A

    Returns: nothing

    Example(s):
        call vgm_c_fnc_init_loading_text;

*/

[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","writing diary entry..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.2;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","checking pockets..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.3;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","cleaning glasses..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.4;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","putting boots on..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.5;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","washing canteen..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.6;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","polishing spork..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.7;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","putting on shades..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.8;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","dusting off shoulders..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.9;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","shining boots..."]] call vgm_c_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 1.0;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>","Ready for Action..."]] call vgm_c_fnc_update_loading_screen;
