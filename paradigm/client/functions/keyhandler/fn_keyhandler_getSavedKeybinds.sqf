/*
    File: fn_keyhandler_getSavedKeybinds.sqf
    Author: Savage Game Design
    Date: 2024-06-14
    Last Update: 2024-06-14
    Public: Yes

    Description:
        Retrieves the saved keybindings for this gamemode.

    Parameter(s):
        N/A

    Returns:
        Saved keybindings, see para_c_fnc_keyhandler_init for the data structure [HashMap]

    Example(s):
        [] call para_c_fnc_keyhandler_getSavedKeybinds;
 */

profileNamespace getVariable vgm_c_keyhandler_savedKeybindsProfileKey

