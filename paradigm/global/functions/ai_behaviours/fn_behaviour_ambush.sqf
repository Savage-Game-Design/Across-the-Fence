/*
    File: fn_behaviour_ambush.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        'Ambush' behaviour. Tells the AI to ambush a specific location.
    
    Parameter(s):
        _group - Group to perform the behaviour.
        _ambushPos - Position to ambush.
    
    Returns:
        Behaviour executed successfully <bool>
    
    Example(s):
		[_group, [1,1,1]] call para_g_fnc_behaviour_ambush
 */

params ["_group", "_ambushPos"];

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Ambush Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

private _currentAmbush = _group getVariable ["currentAmbush", []];

//Reset ambush state if the ambush position has changed.
if !(_currentAmbush isEqualTo _ambushPos) then {
	_group setVariable ["currentAmbush", _ambushPos];
	_group setVariable ["ambushTriggered", false];
	_group setVariable ["ambushStagingPos", []];
};

private _ambushTriggered = _group getVariable ["ambushTriggered", false];
private _areaSize = 100;

if (!_ambushTriggered && {!(playableUnits inAreaArray [_ambushPos, _areaSize, _areaSize, 0, false] isEqualTo [])}) then {
	_ambushTriggered = true;
	_group setVariable ["ambushTriggered", true];

};

if (_ambushTriggered) exitWith {
	private _unitsInArea = playableUnits inAreaArray [_ambushPos, _areaSize, _areaSize, 0, false];
	private _attackPos = _ambushPos;
	if !(_unitsInArea isEqualTo []) then {
		_attackPos = getPos (_unitsInArea select 0);
	};
	[_group, _attackPos] call para_g_fnc_behaviour_attack;
};

if (!_ambushTriggered) then {
	//Move to staging position
	private _ambushStagingPos = _group getVariable ["ambushStagingPos", []];
	if (_ambushStagingPos isEqualTo []) then {
		//TODO: Detect if it's on a road, and set the ambush points either side of the road.
		//Make them closer to point if road, so they can spray down passing vehicles quickly.
		if (isOnRoad _ambushPos) then {
			_ambushStagingPos = _ambushPos getPos [40 + random 60, random 360];
		} else {
			_ambushStagingPos = _ambushPos getPos [100 + random 50, random 360];
		};
		_group setVariable ["ambushStagingPos", _ambushStagingPos];
	};
	private _atPosition = [_group, _ambushStagingPos, "FULL"] call para_g_fnc_behaviour_move_to;

	//Hide
	if (_atPosition) then {
		[_group, "DOWN"] call para_g_fnc_behaviour_set_group_stance;

		if (combatMode _group != "GREEN") then {
			_group setCombatMode "GREEN";
		};	
	};
};

true