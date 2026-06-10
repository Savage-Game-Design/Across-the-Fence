#include "script_component.inc"

/*
    File: fn_skill_investigate_getUnitStateWaveColor.sqf
    Author: Savage Game Design
    Date: 2026-05-06
    Last Update: 2026-05-06
    Public: No

    Description:
        Returns the wave color for sound waves, based on the unit's current status.

        WHITE - Unaware of the player, or engaging in idle behaviour
        AMBER - Agitated, investigating something suspicious
        RED - Actively engaged with the player

    Parameter(s):
        _unit - Unit to check [UNIT]

    Returns:
        A color suitable for drawing sound waves [ARRAY]

    Example(s):
        [cursorObject] call vgm_c_fnc_skill_investigate_getUnitStateWaveColor;
 */

params ["_unit"];

if (behaviour _unit isEqualTo "COMBAT" || group _unit getVariable ["vgm_g_ai_inCombat", false]) exitWith {
    ICON_COLOR_RED
};

if (behaviour _unit isEqualTo "AWARE") exitWith {
    ICON_COLOR_AMBER
};

ICON_COLOR_WHITE
