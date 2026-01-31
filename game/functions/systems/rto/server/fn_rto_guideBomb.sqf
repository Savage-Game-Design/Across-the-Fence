/*
    File: fn_rto_guideBomb.sqf
    Author: Ethan Johnson and Savage Game Design
    Date: 2026-01-31
    Last Update: 2026-01-31
    Public: No

    Description:
        Guides a bomb through velocity transformation so it always hits the target

    Parameter(s):
        _projectile - Projectile object [OBJECT, defaults to OBJNULL]
        _targetPosASL - Target position ASL [PosASL]

    Returns:
        Nothing

    Example(s):
        [_projectile, _targetPos, 30] call vgm_s_fnc_rto_guideBomb;
 */

params
[
	["_projectile", objnull,[objnull]],
	["_targetPosASL", [0, 0, 0],[[]]]
];

if (isNull _projectile || _targetPosASL isEqualTo [0, 0, 0]) exitWith {false};
if !(local _projectile) exitWith {false};

private _projectile_type = typeOf _projectile;
private _projectile_pos = getPosASL _projectile;
private _velocity = velocity _projectile;
private _dir = vectorDir _projectile;
private _up = vectorUp _projectile;
private _distance = _projectile_pos distance _targetPosASL;

private _time = time;
private _total = time + 5;

addMissionEventHandler [
    "EachFrame",
	{
		_thisArgs params ["_projectile","_projectile_pos","_target_pos","_velocity","_dir","_up","_time","_total","_id"];
		_projectile setVelocityTransformation
		[
			_projectile_pos,
			_target_pos,
			_velocity,
			_velocity,
			_dir,
			_dir,
			_up,
			_up,
			linearConversion [_time, _total, time, 0, 1]
		];
		if (isNull _projectile || time > _total) then
		{
            removeMissionEventHandler ["EachFrame", _thisEventHandler];
		};
	},
	[
		_projectile,
		_projectile_pos,
		_targetPosASL,
		_velocity,
		_dir,
		_up,
		_time,
		_total,
		_id
	]
];
