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

private _wp = [_group, currentWaypoint _group];

//If we're moving somewhere, we don't need to do anything!
if (currentWaypoint _group <= count waypoints _group && waypointType _wp == "MOVE") exitWith {false};

//If we've completed all of our waypoints, and we've not exited this script because we're at our destination
//We've either: Never set off, or our waypoint broke (no path?)
//Run the 'repair state machine', a micro state machine with repair strategies.
private _repairStrategy = _group getVariable ["vgm_l_btree_moveTo_repairStrategy", 0];

private _fnc_lastWaypointSuccessful = {
	private _lastWaypoint = waypoints _group select (currentWaypoint _group - 1);
	_groupLeader distance2D waypointPosition _lastWaypoint < 15
};

//Micro state-machine for repairing!
private _repairStrategies = [
	//Strategy 0: Create a waypoint to the destination
	{
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _destPos, -1] call vgm_g_fnc_btree_setWaypoint;
		//If we fail this, move to repair attempt 2.
		_repairStrategy = 1;
	},
	//Strategy 1: Move halfway towards the destination
	{
		private _distance = _destPos distance2D getPos _groupLeader;
		private _newPos = _groupLeader getPos [_distance / 2, _groupLeader getDir _destPos];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, -1] call vgm_g_fnc_btree_setWaypoint;
		_repairStrategy = 2;
	},
	//Strategy 2: Direct move if last waypoint move was successful, else try a short hop forward
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 3;
			call _fnc_performRepair;
		};
	},
	//Strategy 3: A short move forward.
	{
		private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos)];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, -1] call vgm_g_fnc_btree_setWaypoint;
		_repairStrategy = 4;
	},
	//Strategy 4: Direct move if last waypoint move was successful, otherwises try a lateral movement.
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 5;
			call _fnc_performRepair;
		};
	},
	//Strategy 5: A short move sideways.
	{
		private _newPos = _groupLeader getPos [15, (_groupLeader getDir _destPos) + 90];
		[_group, "BTREE_MOVETO", "MOVE", AGLtoASL _newPos, -1] call vgm_g_fnc_btree_setWaypoint;
		_repairStrategy = 4;
	},
	//Strategy 6: Direct move if last waypoint move was successful, otherwise attempt a teleport.
	{
		if (call _fnc_lastWaypointSuccessful) then {
			_repairStrategy = 0;
			call _fnc_performRepair;
		} else {
			_repairStrategy = 7;
			call _fnc_performRepair;
		};
	},
	//Strategy 7: Teleport when no players are nearby. handles AI stuck in objects.
	{
		[format ["btree moveto: Group %1 is *very* stuck, attempting teleport.", _group]] call vgm_g_fnc_logWarning;
		if (allPlayers inAreaArray [getPos _groupLeader, 300, 300] isEqualTo []) then {
            [format ["btree moveto: Group %1 is *very* stuck, teleporting them now.", _group]] call vgm_g_fnc_logWarning;
			private _newPos = _groupLeader getPos [20 + random 20, random 360];
			{
				_x setPos _newPos;
			} forEach units _group;
			_repairStrategy = 1;
			call _fnc_performRepair;
		};
	}
];

private _fnc_performRepair = {
	call (_repairStrategies select _repairStrategy)
};

call _fnc_performRepair;

_group setVariable ["vgm_l_btree_moveTo_repairStrategy", _repairStrategy];

false
