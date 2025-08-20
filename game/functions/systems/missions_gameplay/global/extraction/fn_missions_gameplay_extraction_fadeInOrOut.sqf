/*
    File: fn_missions_gameplay_extraction_fadeInOrOut.sqf
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


params [
    ["_fadeInOrOut", "OUT"],
    ["_seconds", 10],
    ["_players", []]
];

if (_seconds < 0) exitWith {
    nil // return
};

if (count _players isEqualTo 0) exitWith {
    nil // return
};

switch (_fadeInOrOut) do {
    case "IN": {
        [1, "BLACK", _seconds, 1] remoteExec ["BIS_fnc_fadeEffect", _players];
        [_seconds, 0] remoteExec ["fadeSound", _players];
        // [1, "BLACK", _seconds, 1] spawn BIS_fnc_fadeEffect;
        // _seconds fadeSound 0;
    };
    case "OUT": {
        [0, "BLACK", _seconds, 1] remoteExec ["BIS_fnc_fadeEffect", _players];
        [_seconds, 1] remoteExec ["fadeSound", _players];
        // [0, "BLACK", _seconds, 1] spawn BIS_fnc_fadeEffect;
        // _seconds fadeSound 1;
    };
    default {};
};

nil // return
