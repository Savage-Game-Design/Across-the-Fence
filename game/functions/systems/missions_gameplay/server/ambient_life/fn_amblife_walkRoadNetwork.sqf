/*
    File: fn_amblife_walkRoadNetwork.sqf
    Author: AtlasActual
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Walks the road network from a starting position to find a destination
        road position at a target distance. Follows connected roads in one
        direction, avoiding backtracking.

    Parameter(s):
        _startPos  - Starting position [ARRAY]
        _minDist   - Minimum target distance from start [NUMBER]
        _maxDist   - Maximum distance to walk before giving up [NUMBER]

    Returns:
        Position of the far road, or [] if no suitable road found [ARRAY]

    Example(s):
        [getPos vehicle player, 800, 1200] call vgm_s_fnc_amblife_walkRoadNetwork;
 */

params ["_startPos", ["_minDist", 800], ["_maxDist", 1200]];

// Find nearest road to start position
private _startRoads = _startPos nearRoads 50;
if (count _startRoads == 0) then {
    _startRoads = _startPos nearRoads 200;
};
if (count _startRoads == 0) exitWith {
    diag_log format ["[AmbLife] walkRoadNetwork: No roads near %1", _startPos];
    []
};

private _currentRoad = _startRoads # 0;
private _visited = createHashMap;
_visited set [str _currentRoad, true];

private _totalDist = 0;
private _lastPos = getPos _currentRoad;
private _resultPos = [];

// Pick a random initial direction from connected roads
private _connected = roadsConnectedTo _currentRoad;
if (count _connected == 0) exitWith { [] };

_currentRoad = selectRandom _connected;
_visited set [str _currentRoad, true];
private _currentPos = getPos _currentRoad;
_totalDist = _lastPos distance2D _currentPos;
_lastPos = _currentPos;

// Walk the road network
for "_step" from 0 to 200 do {
    if (_totalDist >= _maxDist) exitWith {};

    // Check if we've reached minimum distance
    if (_totalDist >= _minDist) exitWith {
        _resultPos = _lastPos;
    };

    // Get connected roads, filter out visited ones
    _connected = roadsConnectedTo _currentRoad;
    private _unvisited = _connected select {!(_visited getOrDefault [str _x, false])};

    // Dead end - use what we have if it's far enough
    if (count _unvisited == 0) exitWith {
        if (_totalDist >= (_minDist * 0.5)) then {
            _resultPos = _lastPos;
        };
    };

    // Prefer continuing straight (pick the road most aligned with current direction)
    private _prevDir = _lastPos getDir _currentPos;
    private _bestRoad = _unvisited # 0;
    private _bestScore = 999;
    {
        private _nextDir = (getPos _currentRoad) getDir (getPos _x);
        private _angleDiff = abs (_nextDir - _prevDir);
        if (_angleDiff > 180) then { _angleDiff = 360 - _angleDiff };
        if (_angleDiff < _bestScore) then {
            _bestScore = _angleDiff;
            _bestRoad = _x;
        };
    } forEach _unvisited;

    _currentRoad = _bestRoad;
    _visited set [str _currentRoad, true];
    _currentPos = getPos _currentRoad;
    _totalDist = _totalDist + (_lastPos distance2D _currentPos);
    _lastPos = _currentPos;
};

// Final fallback: if we walked but didn't reach minDist, use last position if reasonable
if (_resultPos isEqualTo [] && _totalDist >= (_minDist * 0.5)) then {
    _resultPos = _lastPos;
};

_resultPos
