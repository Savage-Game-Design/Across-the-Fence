/*
    File: fn_suppression_get.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Retrieves the unit's current suppression value.

        Note: Only works where the unit is local.

    Parameter(s):
        _unit - Unit to retrieve value from [OBJECT]

    Returns:
        Current suppression value between 0 and 1 [NUMBER]

    Example(s):
        [cursorObject] call vgm_g_fnc_suppression_get
 */

params ["_unit"];

_unit getVariable ["vgm_l_suppression", 0]
