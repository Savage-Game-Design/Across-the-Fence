/*
	File: fn_spawning_find_valid_position_tracer.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Calculates a valid location to spawn at
		Works by firing a 'tracer' from some distance away from a specific direction, which stops when it gets near to the target pos, or gets too close to a blocking unit.
	
	Parameter(s):
		_tracerEndPos - End position [Position]
		_blockingUnits - Units that prevent spawning near them [Array, defaults to <playableUnits>]
		_attackDir - Attack direction [Number, defaults to <random 360>]
		_minDistance - Minimum spawn distance [Number, defaults to 0]
	
	Returns: nothing

	Example(s): none
*/


params ["_tracerEndPos", ["_blockingUnits", playableUnits], ["_attackDir", random 360], ["_minDistance", 0]];

//How far around each unit blocking happens for.
//Soft block is when visibility checks begin
private _softBlockRadius = 600;
//Hard block is never spawn within this radius
private _hardBlockRadius = 200;

//Adjust the tracer to end _minDistance away.
_tracerEndPos = _tracerEndPos getPos [_minDistance, _attackDir + 180];
private _tracerStart = _tracerEndPos getPos [1500, _attackDir + 180];
private _lastTracerPosition = _tracerStart;
private _tracerPosition = _tracerStart;

//The valid position to spawn at
private _finalPosition = _tracerStart;
//Unit that caused the tracer to stop.
private _stoppedOnTarget = objNull;

if (!isNil "debugAttackTracer" && isNil "tracerMarkers") then {
	tracerMarkers = [];
};

private _index = 0;
while {true} do {
	_index = _index + 1;

	private _stepSize = ((_tracerPosition distance2D _tracerEndPos) / 10) max 100;
	_lastTracerPosition = _tracerPosition;
	_tracerPosition = _tracerPosition getPos [_stepSize, _attackDir];

	//Places debug markers on the map when tracers are fired.
	if (!isNil "debugAttackTracer") then {
		private _mark = createMarker ["Tracer" + str diag_tickTime + str _index, _tracerPosition];
		_mark setMarkerType "mil_dot";
		_mark setMarkerColor "ColorPink";
		tracerMarkers pushBack _mark;
	};

	private _positionIsValid = true;
	private _unitsNearNewPosition = _blockingUnits inAreaArray [_tracerPosition, _softBlockRadius, _softBlockRadius, 0, false];

	if !(_unitsNearNewPosition isEqualTo []) then {
		//Check if any units are within the hard block radius - squads should *never* spawn in this radius
		private _hardBlockUnits = _blockingUnits inAreaArray [_tracerPosition, _hardBlockRadius, _hardBlockRadius, 0, false];
		if !(_hardBlockUnits isEqualTo []) exitWith {
			_positionIsValid = false;
			_stoppedOnTarget = _hardBlockUnits select 0;
		};
		private _unitWithVisibilityIndex = _unitsNearNewPosition findIf {lineIntersectsSurfaces [eyePos _x, AGLtoASL _tracerPosition, _x] isEqualTo []};
		if (_unitWithVisibilityIndex > -1) then { 
			_positionIsValid = false; 
			_stoppedOnTarget = _unitsNearNewPosition select _unitWithVisibilityIndex;
		};
	};

	//If we find a unit, we exit and set the last valid position + which target stopped us.
	if (!_positionIsValid) exitWith {
		if (_tracerPosition isEqualTo _tracerStart) then {
			_finalPosition = [];
		} else {
			_finalPosition = _lastTracerPosition;
		};
	};

	//If we reach the destination, we can spawn at the target location without an issue
	if (_tracerPosition distance2D _tracerEndPos < _stepSize) exitWith {
		_finalPosition = _tracerEndPos;
	};
};

if (!isNil "debugAttackTracer") then {
	private _mark = createMarker ["TracerFinal" + str time, _tracerPosition];
	_mark setMarkerType "mil_dot";
	_mark setMarkerColor "ColorRed";
	tracerMarkers pushBack _mark;
};

[_finalPosition, _stoppedOnTarget]