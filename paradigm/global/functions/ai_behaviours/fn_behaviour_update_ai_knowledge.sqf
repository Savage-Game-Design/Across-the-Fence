/*
    File: fn_behaviour_update_ai_knowledge.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Updates the group's knowledge of the world from external (non-behaviour) sources.
    
    Parameter(s):
        _group - Group to update
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
		[_group] call para_g_fnc_behaviour_update_ai_knowledge
*/

params ["_group"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Update AI Knowledge Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _groupPos = getPos leader _group;

//First, we look at the combat reports, and update the AI's knowledge of nearby combat reports.

private _combatReports = missionNamespace getVariable ["para_g_behaviour_groupCombatReports", []];

private _retainContactInfoRange = _group getVariable "behaviourRetainContactInfoRange";
private _retainContactInfoDuration = _group getVariable "behaviourRetainContactInfoDuration";

private _nearbyReports = _combatReports select {
	//Friendly squad is nearby or enemy position is nearby
	//Works because inAreaArray doesn't actually care what's passed to it, it only considers valid objects/positions...
	!([_x # 1, _x # 3] inAreaArray [getPos leader _group, _retainContactInfoRange, _retainContactInfoRange, 0, false] isEqualTo [])
};

private _reportedEnemyPositions = _group getVariable ["behaviourReportedEnemyPositions", []];
private _nearbyGroupsInContact = _group getVariable ["behaviourNearbyGroupsInContact", []];

//Add any new 
{
	_x params ["_time", "_friendlyPosition", "_friendlyGroup", "_enemyPosition"];
	if !(_enemyPosition isEqualTo []) then {
		_reportedEnemyPositions pushBackUnique [_time, _enemyPosition, false];
	};
	_nearbyGroupsInContact pushBackUnique [_time, _friendlyGroup];
} forEach _nearbyReports;

_reportedEnemyPositions = _reportedEnemyPositions select {
	serverTime < (_x # 0) + _retainContactInfoDuration
	&& (_x # 1) distance2D _groupPos < _retainContactInfoRange
};

_nearbyGroupsInContact = _nearbyGroupsInContact select {
	serverTime < (_x # 0) + _retainContactInfoDuration
	//This will filter null groups too, as it'll report a huge distance as a result of objNull going into distance2D
	&& leader (_x # 1) distance2D _groupPos < _retainContactInfoRange
};

//Update group's knowledge of nearby contacts.
_group setVariable ["behaviourReportedEnemyPositions", _reportedEnemyPositions];
_group setVariable ["behaviourNearbyGroupsInContact", _nearbyGroupsInContact];


//Update group's knowledge of nearby enemy units
private _enemyTrackingRange = _group getVariable "behaviourEnemyTrackingRange";
private _nearbyEnemyUnits = _group getVariable ["behaviourNearbyEnemyUnits", []];

private _nearestEnemy = leader _group findNearestEnemy _groupPos;
if (!isNull _nearestEnemy) then {
	_nearbyEnemyUnits pushBackUnique _nearestEnemy;
};

_nearbyEnemyUnits = _nearbyEnemyUnits select {_x distance2D _groupPos < _enemyTrackingRange && [_group, _x] call para_g_fnc_behaviour_is_valid_target};

_group setVariable ["behaviourNearbyEnemyUnits", _nearbyEnemyUnits];

_group setVariable ["behaviourUnitsAssignedVehicles", units _group select {!isNull assignedVehicle _x}];

//Figure out AI state.
if (currentWaypoint _group >= count waypoints _group) then {
	_group setVariable ["behaviourIdle", true];
} else {
	_group setVariable ["behaviourIdle", false];
	private _currentWaypoint = [_group, currentWaypoint _group];
	_group setVariable ["behaviourHoldingPos", (waypointType _currentWaypoint in ["HOLD", "SENTRY", "LOITER"] && waypointPosition _currentWaypoint distance2D _groupPos < 50)];
};
