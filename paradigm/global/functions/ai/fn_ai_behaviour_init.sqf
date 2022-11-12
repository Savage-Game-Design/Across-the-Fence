/*
	File: fnai_behaviour_init.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
	   Initialises group control script for Mike Force. Sets the group's initial states.
	   Can be safely called multiple times on the same group without issue.
	
	Parameter(s):
	   _group - Group to run the behaviour on
	
	Returns:
		True if the group initialised successfully
	
	Example(s):
		[_group] call para_g_fnc_ai_behaviour_init;
 */

params ["_group"];

if (_group getVariable ["behaviourInitialisedLocally", false]) exitWith {};

//If the group hasn't got a behaviourId, it has never been initialised.
if ((_group getVariable ["behaviourId", ""]) == "") then {
	//Give the group a unique ID, so we can refer to them uniquely in debug output.
	//TODO: Fix this, this won't work with battleye
	_group setVariable ["behaviourId", str serverTime + str random 99999, true];
};

{
	//Disable AUTOCOMBAT on all AI - we're handling the behaviour manually in here.
	_x disableAI "AUTOCOMBAT";
	//Disable fatigue - we want them to be able to run to target positions as fast as possible.
	_x enableFatigue false;
	//Add Hit event handler to trigger combat mode.
	if !(_x getVariable ["behaviourHitHandler", false]) then {
		_x addEventHandler ["Hit", {
			params ["_unit", "_source", "_damage", "_instigator"];
			private _hits = group _unit getVariable ["behaviourUnitHits", []];
			_hits pushBack [serverTime, _instigator];
			group _unit setVariable ["behaviourUnitHits", _hits];
		}];

		_x setVariable ["behaviourHitHandler", true];
	};
} forEach units _group;

_group setVariable ["behaviourDefendPatrolDuration", 300];
_group setVariable ["behaviourDefendRestDuration", 60];

_group setVariable ["behaviourHoldRadius", 50];

_group setVariable ["behaviourInvestigateRange", 300];

_group setVariable ["behaviourRetainContactInfoRange", 600];
_group setVariable ["behaviourRetainContactInfoDuration", 600];

_group setVariable ["behaviourEnemyTrackingRange", 200];

_group setVariable ["remainInCombatFor", 60];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Group initialised", _group getVariable "behaviourId"] call BIS_fnc_logFormat;
};

_group setVariable ["behaviourInitialisedLocally", true];