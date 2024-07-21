/*
	File: fn_btree_moveTo_updateDestination.sqf
	Author:  Savage Game Design
	Public: No

	Description:
        Updates the position the group is currently moving towards.

    Parameter(s):
        _group - Group to move [GROUP]
        _destination - Position to move to [ARRAY]

    Returns:
        Group at destination? [BOOLEAN]

    Example(s):
        [allGroups # 0, [100, 100, 100], "FULL"] call vgm_g_fnc_btree_moveTo_start;
        [allGroups # 0, [100, 200, 100]] call vgm_g_fnc_btree_moveTo_updateDestination;
        [allGroups # 0] call vgm_g_fnc_btree_moveTo_execute;
 */

params ["_group", "_destination"];

_group setVariable ["vgm_l_btree_moveTo_destination", _destination];
_group setVariable ["vgm_l_btree_moveTo_repairAttempts", nil];
_group setVariable ["vgm_l_btree_moveTo_forceRepath", true];
