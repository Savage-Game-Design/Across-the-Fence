/*
    File: fn_carry_canCarry.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-11-03
    Public: No

    Description:
        Check if unit can carry the target.

    Parameter(s):
        _unit   - Unit trying to carry [OBJECT]
        _target - Carried unit         [OBJECT]

    Returns:
        Can carry [BOOL]

    Example(s):
        [player, cursorObject] call vgm_c_fnc_carry_canCarry
 */

params ["_unit", "_target"];

!(alive _target != isAwake _target)
&& lifeState _target == "INCAPACITATED"
&& isNull attachedTo _target // return
