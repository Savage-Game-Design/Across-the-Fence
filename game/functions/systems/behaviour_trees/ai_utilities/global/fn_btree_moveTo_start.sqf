/*
	File: fn_btree_moveTo.sqf
	Author:  Savage Game Design
	Public: No

	Description:
        Makes the group move towards a point as reliably as possible.

    Parameter(s):
        _group - Group to move [GROUP]
        _destination - Location to move to [PosAGL]
        _speedMode - Speed to move at [STRING]
        _completionDistance - How close does the group need to be to the destination to count the move as done? [NUMBER]

    Returns:
        Nothing

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_moveTo;
 */

params ["_group", "_destination", ["_speedMode", ""], ["_completionDistance", 10]];

_group setVariable ["vgm_l_btree_moveTo_destination", _destination];
_group setVariable ["vgm_l_btree_moveTo_completionDistance", _completionDistance];
_group setVariable ["vgm_l_btree_moveTo_repairAttempts", nil];

// Clear their current waypoint to force them to re-path
deleteWaypoint [_group, (count waypoints _group) - 1];

//Set behaviour to AWARE, otherwise they might enter combat and grind to a halt.
//Maybe worth checking if speed is 'FULL'.
if (behaviour leader _group != "AWARE") then {
    _group setBehaviourStrong "AWARE";
};

if (_speedMode != "" && {speedMode _group != _speedMode}) then {
    _group setSpeedMode _speedMode;
};

if (_speedMode == "FULL") then {
    //If we want to move at full speed, make sure they don't crawl.
    [_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;
};

