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
        [allGroups # 0, getPosATL player, "NORMAL", 10] call vgm_g_fnc_btree_action_moveTo;
 */

params ["_group", "_destination", ["_speedMode", ""], ["_completionDistance", 10]];

// Cheap and safe 2D -> 3D conversion
_destination = _destination vectorAdd [0,0,0];

_group setVariable ["vgm_l_btree_moveTo_destination", _destination];
_group setVariable ["vgm_l_btree_moveTo_completionDistance", _completionDistance];
_group setVariable ["vgm_l_btree_moveTo_nextStrategy", nil];
_group setVariable ["vgm_l_btree_moveTo_debug", nil];
_group setVariable ["vgm_l_btree_moveTo_intermediateDestination", nil];
_group setVariable ["vgm_l_btree_moveTo_forceRepath", true];

// Switch out of combat mode to ensure the AI does the move.
// AI in COMBAT tends to get stuck, or take a long time due to using cover.
if (combatBehaviour _group isEqualTo "COMBAT") then {
    _group setBehaviourStrong "AWARE";
};

if (_speedMode != "" && {speedMode _group != _speedMode}) then {
    _group setSpeedMode _speedMode;
};

if (_speedMode == "FULL") then {
    //If we want to move at full speed, make sure they don't crawl.
    [_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;
};

