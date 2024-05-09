/*
    File: fn_wheel_menu_setup_keybinds.sqf
    Author: Savage Game Design
    Date: 2024-05-09
    Last Update: 2024-05-10
    Public: Yes

    Description:
        Sets up keybindings, allowing the wheel menu to be opened and closed with a keypress.

        Must be called during preInit to function correctly.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        [] call para_c_fnc_wheel_menu_setup_keybinds;
 */

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[
    localNamespace,
    "para_c_fetch_keyhandler_actions",
    {
        [
            createHashMapFromArray [
                ["name", "ToggleWheelMenu"],
                ["displayName", "STR_PARA_WHEELMENU_TOGGLE"],
                ["function", para_c_fnc_wheel_menu_toggle_keybind],
                ["onRelease", false],
                ["defaultKey", createHashMapFromArray [
                    ["dikCode", DIK_6]
                ]]
            ]
        ]
    }
] call BIS_fnc_addScriptedEventHandler;
