/*
	File: fn_btree_moveTo.sqf
	Author:  Savage Game Design
	Public: No

	Description:
        Makes the group move towards a point as reliably as possible.

        Primarily deals with "Broken" waypoints, which disappear due to AI not being able to find a path.

        Should only be called on a group which has had vgm_g_fnc_btree_moveTo_start called on it.

    Parameter(s):
        _group - Group to move [GROUP]

    Returns:
        Group at destination? [BOOLEAN]

    Example(s):
        [allGroups # 0, [100, 100, 100], "FULL"] call vgm_g_fnc_btree_moveTo_start;
        [allGroups # 0] call vgm_g_fnc_btree_moveTo_execute;
 */

#define TOLERANCE 3

params ["_group"];

private _groupLeader = leader _group;
private _destPos = _group getVariable ["vgm_l_btree_moveTo_destination", getPosATL _groupLeader];
private _completionDistance = _group getVariable ["vgm_l_btree_moveTo_completionDistance", 10];

// If moveTo_start was never called, this should be true due to the default variables above.
if (_groupLeader distance2D _destPos <= _completionDistance) exitWith {
    // Remove destination, so it doesn't accidentally carry over.
    // This check should still pass due to default values above.
    _group setVariable ["vgm_l_btree_moveTo_debug", "ARRIVED"];
    _group setVariable ["vgm_l_btree_moveTo_destination", nil];
    true
};

private _forceRepath = _group getVariable ["vgm_l_btree_moveTo_forceRepath", false];
private _wp = [_group, currentWaypoint _group];

// Group currently has a valid move waypoint, no action needed.
if (!_forceRepath && currentWaypoint _group < count waypoints _group && waypointType _wp == "MOVE") exitWith {false};
// Force repath is only needed to get past the check above on one iteration.
_group setVariable ["vgm_l_btree_moveTo_forceRepath", false];

// Setup a path handler so we can track the route calculated for the group.
if (_groupLeader getVariable ["vgm_l_btree_moveTo_pathHandler", -1] isEqualTo -1) then {
    _groupLeader setVariable ["vgm_l_btree_moveTo_pathHandler", _groupLeader addEventHandler ["PathCalculated", {
        params ["_unit", "_path"];
        // Path is empty when the AI is stuck. If the destination is unreachable, AI generally paths to the closest point!
        if (_path isEqualTo []) exitWith {
            // Setting this to an impossible intermediate should trigger stuck repair.
            group _unit setVariable ["vgm_l_btree_moveTo_intermediateDestination", [888888, 888888, 888888]];
        };
        group _unit setVariable ["vgm_l_btree_moveTo_intermediateDestination", _path select -1];
    }]];
};

private _intermediateDestination = _group getVariable "vgm_l_btree_moveTo_intermediateDestination";
// Not attempted to move yet - attempt a normal move straight to destination.
if (isNil "_intermediateDestination") exitWith {
    _group setVariable ["vgm_l_btree_moveTo_debug", "INITIAL_MOVE"];
    [_group, "BTREE_MOVETO", "MOVE", AGLtoASL _destPos, -1] call vgm_g_fnc_btree_setWaypoint;
    false
};

// At this point - the group has attempted a move, the waypoint has failed, so some action is needed.

// Intermediate destination has been reached - this might be the final destination. The only way to check is by attempting to repath.
if (_intermediateDestination distance2D getPosASL _groupLeader < TOLERANCE) exitWith {
    // Unstuck if we've reached our destination!
    _group setVariable ["vgm_l_btree_moveTo_nextStrategy", 0];
    private _lastIntermediate = _group getVariable ["vgm_l_btree_moveTo_lastIntermediateDestination", [999999, 999999, 999999]];
    _group setVariable ["vgm_l_btree_moveTo_lastIntermediateDestination", _intermediateDestination];

    // Pathfinding hasn't found another route - this is the best we're going to do. Exit.
    if (_lastIntermediate distance2D _intermediateDestination < TOLERANCE) exitWith {
        // Remove destination, so it doesn't accidentally carry over.
        // This check should still pass due to default values above.
        _group setVariable ["vgm_l_btree_moveTo_debug", "ARRIVED_CLOSEST"];
        _group setVariable ["vgm_l_btree_moveTo_destination", nil];
        true
    };

    // Attempt to path from the current intermediate to the end destination.
    _group setVariable ["vgm_l_btree_moveTo_debug", "MOVE_AFTER_INTERMEDIATE"];
    [_group, "BTREE_MOVETO", "MOVE", AGLtoASL _destPos, -1] call vgm_g_fnc_btree_setWaypoint;
    false
};

// Route failed - AI is probably stuck, attempt stuck repair.

private _repairStrategies = [
    //Strategy 0: A short move forward.
    {
        private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos)];
        [_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, 0] call vgm_g_fnc_btree_setWaypoint;
    },
    //Strategy 1: A short move sideways.
    {
        private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos) + 90];
        [_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, 0] call vgm_g_fnc_btree_setWaypoint;
    },
    //Strategy 2: Teleport when no players are nearby. handles AI stuck in objects.
    {
        if (allPlayers inAreaArray [getPos _groupLeader, 100, 100] isEqualTo []) then {
            [format ["btree moveto: Group %1 is *very* stuck, teleporting them now.", _group]] call vgm_g_fnc_logWarning;
            private _newPos = _groupLeader getPos [10, _groupLeader getDir _destPos];
            {
                _x setPos _newPos;
            } forEach units _group;
            // Set up a direct move after teleporting.
            call (_repairStrategies # 0);
        } else {
            [format ["btree moveto: Group %1 is *very* stuck, cannot teleport due to nearby players.", _group]] call vgm_g_fnc_logWarning;
        };
    }
];

_group setVariable ["vgm_l_btree_moveTo_debug", "STUCK_REPAIR"];

private _nextStrategy = _group getVariable ["vgm_l_btree_moveTo_nextStrategy", 0];
private _chosenStrategy = _nextStrategy min (count _repairStrategies - 1);
[] call (_repairStrategies # _chosenStrategy);

_group setVariable ["vgm_l_btree_moveTo_nextStrategy", _nextStrategy + 1];

false
