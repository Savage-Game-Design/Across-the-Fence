/*
    File: fn_missions_gameplay_extraction_callExtract.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2025-10-27
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
    ["_lzPosition", []],
    ["_useExactLzPosition", false],
    ["_class", "vn_b_air_uh1d_02_07"],
    ["_distance", 3000],
    ["_originPos", markerPos "vgm_shared_hub"]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    format ["Unable to extract, no mission with id: %1", _missionId] call vgm_g_fnc_logError;
};

private _playerGroup = _mission get "public" get "group";
if (!(_playerGroup getVariable ["vgm_missions_extraction_canRequest", true])) exitWith {
    format ["Already requested an extraction: %1", _missionId] call vgm_g_fnc_logError;
};
_playerGroup setVariable ["vgm_missions_extraction_canRequest", false, true];

// Only doing this calculation serverside, as the client doesn't have target box location data.
if (_lzPosition isEqualTo []) then {
    private _targetBox = _mission get "public" get "targetZone";
    private _lzs = ([_targetBox] call vgm_s_fnc_loc_getTargetBoxLocations) get "lz";
    private _playerToExtract = leader _playerGroup;
    if (isNull _playerToExtract) then {
        _playerToExtract = selectRandom units _playerGroup;
    };
    private _lzsByDistance = _lzs apply {[_x distance2D _playerToExtract, _x]};
    _lzsByDistance sort true;

    _lzPosition = _lzsByDistance # 0 # 1;
    _useExactLzPosition = true;
};

if (_lzPosition isEqualTo []) exitWith {
    format ["Unable to extract, no LZ position found: %1", _missionId] call vgm_g_fnc_logError;
};

// spawn the helicopter, coming from the direction of the origin pos
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;
_playerGroup setVariable ["vgm_missions_extraction_helicopter", _helicopter, true];

private _spawnPos = _lzPosition getPos [_distance, _lzPosition getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;
_helicopter setDir random 360;

private _group = group _helicopter;

private _safeLzPositionATL = _lzPosition findEmptyPosition [0, 100, _class];
if (_useExactLzPosition || _safeLzPositionATL isEqualTo []) then {
    _safeLzPositionATL = _lzPosition;
};
_safeLzPositionATL set [2, 0];

private _helipad = createVehicle [["Land_HelipadEmpty_F", "Land_HelipadCircle_F"] select is3DENPreview, [0,0,0], [], 0, "NONE"];
_helipad setPosATL _safeLzPositionATL;

private _wpPos = _lzPosition getPos [100 min _distance, _lzPosition getDir _originPos];

private _landWp = _group addWaypoint [_wpPos, 0];
_helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];
_landWp setWaypointStatements ["true", toString {
    if (!isServer) exitWith {};
    [vehicle this] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
}];

private _script = [_missionId, _mission, _helicopter, _helipad] spawn {
    params ["_missionId", "_mission", "_helicopter", "_helipad"];
    private _playerGroup = _mission get "public" get "group";
    waitUntil {
        private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
        private _everyoneBoarded = _alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo [];
        private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
        private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];

        _everyoneBoarded || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime)
    };

    _helicopter setVariable ["vgm_missions_extractionBoarded", true];
    _helicopter flyInHeight [100, true];
    _helicopter setCaptive false;

    ["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    format ["Extraction script successful: %1, %2, %3", _missionId, _helicopter] call vgm_g_fnc_logInfo;

    private _landWp = group _helicopter addWaypoint [markerPos "vgm_mission_heli_despawn", 0];
    sleep 25;
    private _endType = ["FAILURE", "SUCCESS"] select (units _playerGroup findIf {_x in _helicopter} > -1);
    [_missionId, _endType] call vgm_s_fnc_missions_endMission;
    waitUntil {crew _helicopter findIf {isPlayer _x} == -1};
    sleep 25;
    {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
    deleteVehicle _helicopter;
    deleteVehicle _helipad;
};

_group setVariable ["vgm_missions_extractionScript", _script];

["vgm_missions_gameplay_extractionStarted", [_missionId, +_safeLzPositionATL, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

// clean up extraction if mission fails
call {
    if (isNil "vgm_missions_gameplay_extractionMissionEndedHandlers") then {
        vgm_missions_gameplay_extractionMissionEndedHandlers = createHashMap;
    };

    private _ehEndedId = ["vgm_mission_ended", [[_helicopter, _group], {
        (_this#0) params ["_missionId", "_endType"];
        (_this#1) params ["_helicopter", "_group"];

        private _ehId = vgm_missions_gameplay_extractionMissionEndedHandlers deleteAt _missionId;
        [_ehId] call para_g_fnc_event_unsubscribe;

        if (_endType != "FAILURE") exitWith {};

        format ["Extraction script cleanup, mission failed: %1, %2, %3", _missionId, _helicopter, _group] call vgm_g_fnc_logInfo;

        terminate (_group getVariable ["vgm_missions_extractionScript", scriptNull]);

        {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
        deleteVehicle (_helicopter getVariable ["vgm_mission_extraction_helipad", objNull]);
        deleteVehicle _helicopter;

    }]] call para_g_fnc_event_subscribeLocal;
    vgm_missions_gameplay_extractionMissionEndedHandlers set [_missionId, _ehEndedId];
};

_helicopter // return
