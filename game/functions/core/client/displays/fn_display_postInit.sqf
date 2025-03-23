/*
    File: fn_display_postInit.sqf
    Author: Savage Game Design
    Date: 2024-03-24
    Last Update: 2024-08-09
    Public: No

    Description:
        PostInit for display related functionalities.
 */

[] call para_c_fnc_keybindingsMenu_init;

// add notepad to map
[] spawn {
    waitUntil {!isNull findDisplay 12};
    findDisplay 12 ctrlCreate ["VGM_RscNotepad", -1];
};
