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

params ["_group"];

private _groupLeader = leader _group;
private _destPos = _group getVariable ["vgm_l_btree_moveTo_destination", getPos _groupLeader];
private _completionDistance = _group getVariable ["vgm_l_btree_moveTo_completionDistance", 10];

// If moveTo_start was never called, this should be true due to the default variables above.
if (_groupLeader distance2D _destPos <= _completionDistance) exitWith {
    // Remove destination, so it doesn't accidentally carry over.
    // This check should still pass due to default values above.
    _group setVariable ["vgm_l_btree_moveTo_destination", nil];
    true
};

private _forceRepath = _group getVariable ["vgm_l_btree_moveTo_forceRepath", false];
private _wp = [_group, currentWaypoint _group];

// Group currently has a valid move waypoint, no action needed.
if (!_forceRepath && currentWaypoint _group < count waypoints _group && waypointType _wp == "MOVE") exitWith {false};

// Different types of move, designed to un-stick the AI from their current position.
private _repairStrategies = [
	//Strategy 0: Create a waypoint to the destination
	{
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _destPos, _completionDistance] call vgm_g_fnc_btree_setWaypoint;
	},
	//Strategy 1: Move halfway towards the destination
	{
		private _distance = _destPos distance2D getPos _groupLeader;
		private _newPos = _groupLeader getPos [_distance / 2, _groupLeader getDir _destPos];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, (_distance / 20) max _completionDistance] call vgm_g_fnc_btree_setWaypoint;
	},
	//Strategy 2: A short move forward.
	{
		private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos)];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, 5] call vgm_g_fnc_btree_setWaypoint;
	},
	//Strategy 3: A short move sideways.
	{
		private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos) + 90];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, 5] call vgm_g_fnc_btree_setWaypoint;
	},
	//Strategy 4: Teleport when no players are nearby. handles AI stuck in objects.
	{
		[format ["btree moveto: Group %1 is *very* stuck, attempting teleport.", _group]] call vgm_g_fnc_logWarning;
		if (allPlayers inAreaArray [getPos _groupLeader, 200, 200] isEqualTo []) then {
            [format ["btree moveto: Group %1 is *very* stuck, teleporting them now.", _group]] call vgm_g_fnc_logWarning;
			private _newPos = _groupLeader getPos [20 + random 20, random 360];
			{
				_x setPos _newPos;
			} forEach units _group;
            // Set up a direct move after teleporting.
			call (_repairStrategies # 0);
		};
	}
];

private _waypoints = waypoints _group;

//If we've completed all of our waypoints, and we've not exited this script because we're at our destination
//We've either: Never set off, or our waypoint broke (no path?)
//Run the 'repair state machine', a micro state machine with repair strategies.
private _repairAttempts = _group getVariable ["vgm_l_btree_moveTo_repairAttempts", 0];

if (_repairAttempts > 0 && count _waypoints >= 1) then {
    private _lastWaypoint = _waypoints select (currentWaypoint _group - 1);
    private _lastWaypointSuccessful = _groupLeader distance2D waypointPosition _lastWaypoint < waypointCompletionRadius _lastWaypoint;
    if (_lastWaypointSuccessful) then {
        _repairAttempts = 0;
    };
};


private _chosenStrategy = _repairAttempts min (count _repairStrategies - 1);
[] call (_repairStrategies # _chosenStrategy);

_group setVariable ["vgm_l_btree_moveTo_repairAttempts", _repairAttempts + 1];
_group setVariable ["vgm_l_btree_moveTo_forceRepath", false];

false
