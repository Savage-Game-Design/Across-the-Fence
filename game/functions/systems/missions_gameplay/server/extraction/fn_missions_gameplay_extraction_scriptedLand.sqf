/*
    File: fn_missions_gameplay_extraction_scriptedLand.sqf
    Author: Savage Game Design
    Date: 2025-01-03
    Last Update: 2025-01-09
    Public: No

    Description:
        Scripted helicopter land.

    Parameter(s):
        _helicopter - Helicopter that will be guided to the helipad [OBJECT]

    Returns:
        Nothing

    Example(s):
        private _landWp = _group addWaypoint [_wpPos, 0];
        _helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];
        _landWp setWaypointStatements ["true", toString {
            if (!isServer) exitWith {};
            [vehicle this] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
        }];
 */

params ["_helicopter"];

private _helipad = _helicopter getVariable ["vgm_mission_extraction_helipad", objNull];

private _fnc_surfaceVectorDir = {
	params ["_pos"];
	private _pos2d = _pos select [0, 2];

	private _normal = surfaceNormal _pos2d select [0, 2];
	_pos2d vectorFromTo (_pos2d vectorAdd _normal) // return
};

private _fnc_slopeSteepness = {
    params ["_pos"];
    private _up = [0, 0, 1];
	private _surf = surfaceNormal _pos;
	private _dot = _up vectorDotProduct _surf;
	acos _dot // return
};

/*
Pretty ASCII "picture" to visualize the positions
(start)🚁0 ----.
                \
                 1 (midpoint)
                 |
                 |
                 2 (landpos)
*/
private _pos0 = getPosASL _helicopter;
private _pos1 = getPosASL _helipad;
private _pos2 = getPosASL _helipad;
_pos1 set [2, (_pos0#2 - 15) max (getTerrainHeightASL _pos1 + 25)];
_pos2 = _pos2 vectorAdd [0,0,10];

// TODO, in future we could figure needed forwards velocity for smoother movement
private _v0 = [0,0,0];

private _dir0 = vectorDir _helicopter;
private _dir1 = _pos0 vectorFromTo _pos1;
private _dir2 = +_dir1;

// compute if heli should land on the ground or hover (on steep slopes)
private _landZ = -1;
if (([_pos2] call _fnc_slopeSteepness) > 20) then {
    private _surfDir = [_pos2] call _fnc_surfaceVectorDir;
    private _slopeExtremes = [1, 2, 4, 6] apply {
        private _slopeTop = _pos2 vectorAdd (_surfDir vectorMultiply (_x * -1));
        getTerrainHeightASL _slopeTop // return
    };
    private _slopeHeight = selectMax _slopeExtremes;
    // landpos hovering
    _landZ = (_slopeHeight - (getPosASL _helipad#2)) + 1.5;
    _pos2 set [2, _slopeHeight+10];
    // landpos direction sideways to slope
    private _dir2_0 = [_surfDir, 90] call BIS_fnc_rotateVector2D;
    private _dir2_1 = [_surfDir, -90] call BIS_fnc_rotateVector2D;
    // determine which direction is closer to current helo direction
    _dir2 = selectMax ([_dir2_0, _dir2_1] apply {[_x vectorDotProduct _dir2, _x]}) select 1;
};

_helicopter flyInHeight [_landZ, true];

#ifdef __A3_DEBUG__
    if (is3DENPreview) then {
        private _posLand = +_pos2;
        _posLand set [2, getTerrainHeightASL _posLand + _landZ];

        vgm_debug_scriptedLandLines = [
            [_pos0, _pos1] apply {ASLToAGL _x},
            [_pos1, _pos2] apply {ASLToAGL _x},
            [_pos2, _posLand] apply {ASLToAGL _x}
        ];
        vgm_debug_scriptedLandIcons = [
            [ASLToAGL _posLand, "", format ["Land Z: %1", _landZ]]
        ];
    };
#endif

private _pfhArgs = [_helicopter, time, _v0, [_dir0, _dir1, _dir2], [_pos0, _pos1, _pos2], _landZ];

// "jail" the helicopter and guide it towards the landing position
addMissionEventHandler ["EachFrame", {
    if (isGamePaused) exitWith {};
    _thisArgs params ["_helicopter", "_t0", "_v0", "_dirs", "_positions", "_landZ"];
    if (isNull _helicopter || {_helicopter getVariable ["vgm_missions_extractionBoarded", false]}) exitWith {
        removeMissionEventHandler ["EachFrame", _thisEventHandler]
    };
#ifdef __A3_DEBUG__
    {
        private _color = [[1,0,0,1], [0,1,0,1], [0,0,1,1]] select (_forEachIndex % 3);
        drawLine3D [_x#0, _x#1, _color];
    } forEach vgm_debug_scriptedLandLines;
    {
        drawIcon3D [_x#1, [1,1,1,1], _x#0, 1, 1, 0, _x#2];
    } forEach vgm_debug_scriptedLandIcons;
#endif

    _dirs params ["_dir0", "_dir1", "_dir2"];
    _positions params ["_pos0", "_pos1", "_pos2"];

    private _t = linearConversion [_t0, _t0 + 12, time, 0, 1, true];
    if (_t < 1) exitWith {
        _helicopter setVelocityTransformation [
            _pos0,
            _pos1,
            _v0,
            [0,0,0],
            _dir0,
            _dir1,
            [0,0,1],
            [0,0,1],
            _t
        ];
    };

    private _t = linearConversion [_t0 + 13.5, _t0 + 19.5, time, 0, 1, true];
    if (_t < 1) exitWith {
        _helicopter setVelocityTransformation [
            _pos1,
            _pos2,
            [0,0,-2],
            [0,0,0],
            _dir1,
            _dir2,
            [0,0,1],
            [0,0,1],
            _t
        ];
    };

    if !(_helicopter getVariable ["vgm_missions_extractionLanded", false]) then {
        _helicopter setVariable ["vgm_missions_extractionLanded", true, true];
    };

    if (diag_frameNo % 2 == 0) then {
        private _v1 = velocity _helicopter;
        _v1 set [0, 0];
        _v1 set [1, 0];
        _helicopter setVelocity _v1;
        _helicopter flyInHeight [_landZ + (time % 5 / 10), true];
    };

    // unflip the heli if it somehow got flipped
    if (diag_frameNo % 30 == 0) then {
        private _pitchBank = _helicopter call BIS_fnc_getPitchBank;
        if (count (_pitchBank select {abs _x > 15}) > 0) then {
            _helicopter setVectorUp [0,0,1];
        };
    };
}, _pfhArgs];
