/*
    File: fn_wheelMenu_preInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Registers the wheel menu keybind (key 6) with the keyhandler system.
        Paradigm's own wheel_menu_preInit is not marked as preInit=1 in its
        CfgFunctions, so the keybind never gets registered. We do it here
        during preInit so it gets buffered and processed alongside all other
        VGM keybinds when keyhandler_init runs at postInit.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_wheelMenu_preInit;
*/

if (!hasInterface) exitWith {};

// Register the wheel menu keybind directly (Paradigm's fn_wheel_menu_preInit uses
// an unlocalized string key "STR_PARA_WHEELMENU_TOGGLE"). We register it ourselves
// with a proper display name.
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[
    createHashMapFromArray [
        ["name", "ToggleWheelMenu"],
        ["displayName", "Radio Action Menu"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_6]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;

["ToggleWheelMenu", para_c_fnc_wheel_menu_toggle_keybind] call para_c_fnc_keyhandler_addGeneralActionHandler;
