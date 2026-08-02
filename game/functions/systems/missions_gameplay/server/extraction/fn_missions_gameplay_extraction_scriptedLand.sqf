/*
    File: fn_missions_gameplay_extraction_scriptedLand.sqf
    Author: Savage Game Design
    Date: 2025-01-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Vanilla helicopter landing using landAt "GetIn" mode. The AI handles
        the full flight, approach, and touchdown natively. Engines stay
        running on the ground. An EachFrame handler monitors for touchdown
        and provides post-landing stability. Automatically cancels the
        landing hold when vgm_missions_extractionBoarded is set, allowing
        departure.

        Safe to call multiple times on the same helicopter (e.g. alternate
        LZ redirect) — previous monitors are cleaned up first.

    Parameter(s):
        _helicopter - Helicopter to land [OBJECT]

    Returns:
        Nothing

    Example(s):
        _helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];
        [_helicopter] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
 */

params ["_helicopter"];

private _helipad = _helicopter getVariable ["vgm_mission_extraction_helipad", objNull];
private _group = group _helicopter;

// Remove any existing landing monitor from a previous call (e.g. alternate LZ redirect)
private _existingPFH = _helicopter getVariable ["vgm_scriptedLand_pfh", -1];
if (_existingPFH > -1) then {
	removeMissionEventHandler ["EachFrame", _existingPFH];
};

// Reset landing state
_helicopter setVariable ["vgm_missions_extractionLanded", false, true];

// Clear waypoints
while {count waypoints _group > 0} do {
	deleteWaypoint [_group, 0];
};

// Vanilla AI landing — fly to helipad and land, engines stay running
private _result = _helicopter landAt [_helipad, "GetIn", 600];
if (!_result) then {
	format ["scriptedLand: landAt failed for %1 at %2", _helicopter, getPosATL _helipad] call vgm_g_fnc_logWarning;
};

// EachFrame: detect touchdown, post-landing stability
private _pfhId = addMissionEventHandler ["EachFrame", {
	if (isGamePaused) exitWith {};
	_thisArgs params ["_helicopter", "_helipad"];

	// On departure: cancel landAt so the helicopter follows its departure waypoint
	if (isNull _helicopter || {_helicopter getVariable ["vgm_missions_extractionBoarded", false]}) exitWith {
		if (!isNull _helicopter) then {
			_helicopter landAt [getPosWorld _helicopter, "None"];
		};
		removeMissionEventHandler ["EachFrame", _thisEventHandler];
	};

	// Detect touchdown
	if !(_helicopter getVariable ["vgm_missions_extractionLanded", false]) exitWith {
		private _state = landAt _helicopter;
		private _autopilot = _state # 4;
		if (_autopilot isEqualTo "REACHED" || {isTouchingGround _helicopter && speed _helicopter < 3}) then {
			_helicopter setVariable ["vgm_missions_extractionLanded", true, true];
		};
	};

	// Post-landing: prevent drift on slopes
	if (diag_frameNo % 2 == 0) then {
		private _v = velocity _helicopter;
		_v set [0, 0];
		_v set [1, 0];
		_helicopter setVelocity _v;
	};

	// Unflip protection
	if (diag_frameNo % 30 == 0) then {
		private _pitchBank = _helicopter call BIS_fnc_getPitchBank;
		if (count (_pitchBank select {abs _x > 15}) > 0) then {
			_helicopter setVectorUp [0, 0, 1];
		};
	};
}, [_helicopter, _helipad]];

_helicopter setVariable ["vgm_scriptedLand_pfh", _pfhId];
