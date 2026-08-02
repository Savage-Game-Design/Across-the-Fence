/*
    File: fn_skill_investigate_addAction.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2026-03-04
    Public: No

    Description:
        Previously added the "Stop, Listen" scrollwheel action to the player.
        This has been moved to the wheel menu (cfg_wheel_menu.hpp).
        The keybind (T) still works independently via skill_investigate_postInit.
        This function is kept as a no-op for backwards compatibility with callers.

    Parameter(s):
        _player - Player unit [OBJECT]

    Returns:
        Nothing

    Example(s):
        player call vgm_c_fnc_skill_investigate_addAction
 */

// Action moved to wheel menu. Keybind T still works independently.
