/*
    File: fn_btree_setGroupStance
    Author:  Savage Game Design
    Public: Yes

    Description:
        Sets whether a group of units should be prone, stood or auto.

    Parameter(s):
        _group - Group to apply position change to. [GROUP]
        _pos - Position to put them in. One of 'UP', 'DOWN', 'MIDDLE' or 'AUTO'. [STRING]
        _force - Runs the set position command, even if they're already set in that pos. [BOOLEAN]

    Returns:
        True if units are already in that stance, false otherwise. [BOOLEAN]

    Example(s):
        [_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;
 */

params ["_group", "_pos", ["_force", false]];

if (_group getVariable ["vgm_l_btree_unitPos", ""] != _pos) exitWith {
    {
        _x setUnitPos _pos;
    } forEach units _group;
    _group setVariable ["vgm_l_btree_unitPos", _pos];
    false
};

true
