/*
	File: fn_behaviour_combat_check.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Combat Check' behaviour. Checks if a unit should be in combat, and if so, runs combat behaviours.
	
	Parameter(s):
		_group - Group to run the behaviour on.
	
	Returns:
		Unit is in combat (behaviour ran successfully) [BOOL]
	
	Example(s):
		_myGroup call para_g_fnc_behaviour_combat_check;
*/

params ["_group"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Combat Check Execution", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _inCombat = _group getVariable ["behaviourInCombat", false];
private _shouldBeInCombat = false;

//Pull all 'recent' hits from the AI. 'Recent' is relative, and basically used only for tuning the AI behaviour.
private _unitHits = _group getVariable ["behaviourUnitHits", []] select {_x # 0 > serverTime - 120};

if !(_unitHits isEqualTo []) then {
	_shouldBeInCombat = true;
};

_group setVariable ["behaviourUnitHits", _unitHits, true];

if (_shouldBeInCombat) exitWith {
	if (!_inCombat) then {
		[_group]  call para_g_fnc_behaviour_report_combat;
	};
	_group setVariable ["behaviourInCombat", true];
	_group call para_g_fnc_behaviour_combat;
	true
};

_group setVariable ["behaviourInCombat", false];
false