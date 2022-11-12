/*
    File: fn_behaviour_investigate_nearby_combat.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Investigate nearby combat' behaviour. Sends the squad to search areas near to reported combat zones.
    
    Parameter(s):
        _group
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
		_group call para_g_fnc_behaviour_investigate_nearby_combat
*/

params ["_group"];

scopeName "behaviour";

private _groupPos = getPos leader _group;
private _investigateRange = _group getVariable "behaviourInvestigateRange";
private _reportedEnemyPositions = _group getVariable ["behaviourReportedEnemyPositions", []];
private _nearbyGroupsInContact = _group getVariable ["behaviourNearbyGroupsInContact", []];

if !(_reportedEnemyPositions isEqualTo []) then {
	private _nearestEnemyPosition = _reportedEnemyPositions # 0;
	private _closestDist = (_nearestEnemyPosition # 1) distance2D _groupPos;

	{
		_x params ["_time", "_pos"];	
		private _dist = _pos distance2D _groupPos;
		if (_dist < _closestDist) then {
			_nearestEnemyPosition = _x;
			_closestDist = _dist;
		};
	} forEach _reportedEnemyPositions;

	//If we're on-top of the position, we consider it investigated.
	if (_closestDist < 30) then {
		_reportedEnemyPositions = _reportedEnemyPositions - _nearestEnemyPosition;
		_group setVariable ["behaviourReportedEnemyPositions", _reportedEnemyPositions];
		//TODO: Add pursuit targets to AI knowledge in certain radius.
		//TODO: Fix issue where the AI is stood in the radius, but because the position is globally reported still, will keep getting it added to reportedEnemyPositions.

		true breakOut "behaviour";
	};

	//Only investigate it targets are close enough.
	if (_closestDist < _investigateRange) then {
		[_group, _nearestEnemyPosition # 1] call para_g_fnc_behaviour_attack;
		true breakOut "behaviour";
	};

};

//TODO: Behaviour involving supporting the group.

false
