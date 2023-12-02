/*
    File: fn_missions_gameplay_extraction_callExtract.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2023-12-02
    Public: No

    Description:
        Starts helicopter extraction for the given mission. Auto-completes the mission once all players boarded the heli.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]
        _lzPosition - Position where heli will land [ARRAY]

    Returns:
        Helicopter [OBJECT]

    Example(s):
        [call vgm_c_fnc_missions_getCurrentMission get "id", getPos player] remoteExecCall ["vgm_s_fnc_missions_gameplay_extraction_startExtract", 2]
 */

params [
    "_missionId",
    "_lzPosition",
    ["_class", "vn_b_air_uh1d_02_07"],
    ["_distance", 3000],
    ["_originPos", markerPos "vgm_shared_hub"]
];

private _mission = localNamespace getVariable "vgm_missions" get _missionId;

if (isNil "_mission") exitWith {
    format ["Unable to extract, no mission with id: %1", _missionId] call vgm_g_fnc_logError;
};

// spawn the helicopter, coming from the direction of the origin pos
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;

private _spawnPos = _lzPosition getPos [_distance, _lzPosition getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;
_helicopter setDir random 360;

private _group = group _helicopter;

private _safeLzPosition = _lzPosition findEmptyPosition [0, 100, _class];
if (_safeLzPosition isEqualTo []) then {
    _safeLzPosition = _lzPosition;
};

// having WP directly above LZ makes LAND more robust
_group addWaypoint [_safeLzPosition, 0];

private _landWp = _group addWaypoint [_safeLzPosition, 0];
_landWp setWaypointType "SCRIPTED";
_landWp setWaypointScript "vn\missions_f_vietnam\functions\waypoint\fn_waypoint_land.sqf";
_landWp setWaypointStatements ["true", toString {
    group this setVariable ["vgm_missions_extractionLanded", true, true];
    vehicle this flyInHeight 0;
}];

private _script = [_missionId, _mission, _helicopter] spawn {
    params ["_missionId", "_mission", "_helicopter"];
    private _playerGroup = _mission get "public" get "group";
    waitUntil {
        private _alivePlayers = units _playerGroup select {alive _x && lifeState _x != "INCAPACITATED"};
        _alivePlayers findIf {!(_x in _helicopter)} == -1 // all alive players are inside the heli
    };

    _helicopter flyInHeight [100, true];
    _helicopter setCaptive false;

    private _landWp = group _helicopter addWaypoint [markerPos "vgm_mission_heli_despawn", 0];
    sleep 25;
    [_missionId] call vgm_s_fnc_missions_endMission;
    waitUntil {crew _helicopter findIf {isPlayer _x} == -1}
    sleep 5;
    {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
    deleteVehicle _helicopter;
};

_group setVariable ["vgm_missions_extractionScript", _script];

_helicopter // return
