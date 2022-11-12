/*
	File: fn_fallthrough_checker_job.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Initialises the world fallthrough checker, which attempts to repair or delete objects
		which fall out of the world.

	Parameter(s): none

	Returns: nothing

	Example(s):
		["fallthrough_checker", para_g_fnc_fallthrough_checker_job, [], 1] call para_g_fnc_scheduler_add_job;
*/

private _entriesProcessed = 0;

while {count fallthrough_checker_objects_to_check > _entriesProcessed && {fallthrough_checker_objects_to_check # _entriesProcessed # 0 < time}} do {
	private _data = fallthrough_checker_objects_to_check select _entriesProcessed;
	_entriesProcessed = _entriesProcessed + 1;

	_data params ["_time", "_object", "_checkCount"];
	// We check -1 as some objects will "naturally" clip under terrain a little bit.
	if (isNull _object || getPosATL _object # 2 > -1) then {
		continue;
	};

	// Attempt to fix on first check
	// Delete if the fix didn't work (i.e, it's already been fixed once)
	if (_checkCount == 0) then {
		private _objectPos = getPosASL _object;
		private _heightIntersections = lineIntersectsSurfaces [
			[_objectPos # 0, _objectPos # 1, 999], 
			[_objectPos # 0, _objectPos # 1, -1], 
			objNull, 
			objNull, 
			true, 
			1, 
			"GEOM"
		];

		if (count _heightIntersections > 0) then {
			_object setPosASL (_heightIntersections # 0 # 0 vectorAdd [0, 0, 1]);
		} else {
			_object setPosATL [_objectPos # 0, _objectPos # 1, 1];
		};

		[_object, 1] call para_g_fnc_fallthrough_checker_add_object;
	} else {
		deleteVehicle _object;
	};
};

fallthrough_checker_objects_to_check deleteRange [0, _entriesProcessed];