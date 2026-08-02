/*
    File: fn_skill_staboExtract_startExtract.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Server-side STABO extraction orchestrator. Spawns UH-1D 3000m away,
        flies to caller position, hovers above the canopy, drops a rope,
        waits for all alive non-unconscious players to hook up (or evacNow/
        evacAt triggers), then lifts off, flies away, and ends the mission.

    Parameter(s):
        _missionId  - ID of the mission [NUMBER]
        _lzPosition - Position where heli will hover [ARRAY]

    Returns:
        Nothing

    Example(s):
        [missionId, getPosATL player] remoteExecCall ["vgm_s_fnc_skill_staboExtract_startExtract", 2]
 */

#define HOVER_HEIGHT_ATL 35
#define MAX_PLAYERS 6

params ["_missionId", "_lzPosition"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["STABO: Unable to extract, no mission with id: %1", _missionId] call vgm_g_fnc_logError;
};

private _playerGroup = _mission get "public" get "group";
private _class = "vn_b_air_uh1d_02_07";
private _originPos = markerPos "vgm_shared_hub";
private _distance = 3000;

// Spawn the helicopter coming from the direction of the origin pos
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;
_playerGroup setVariable ["vgm_missions_extraction_helicopter", _helicopter, true];
_playerGroup setVariable ["vgm_missions_stabo_helicopter", _helicopter, true];

private _spawnPos = _lzPosition getPos [_distance, _lzPosition getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;
_helicopter setDir (_spawnPos getDir _lzPosition);

// Fixed hover height above terrain
private _hoverHeight = HOVER_HEIGHT_ATL;

_helicopter setVariable ["vgm_missions_stabo_hoverHeight", _hoverHeight, true];
_helicopter setVariable ["vgm_missions_stabo_hookedCount", 0, true];

format ["STABO: Hover height calculated at %1m AGL", _hoverHeight] call vgm_g_fnc_logInfo;

// Voice line: extraction inbound
private _pilot = driver _helicopter;
[5, "extraction", "inbound", false, _pilot] call vgm_s_fnc_voicelines_playDelayed;

// Fly toward the LZ position
private _group = group _helicopter;
private _hoverPosATL = +_lzPosition;
_hoverPosATL set [2, _hoverHeight];

// Set a waypoint directly at the hover position
private _wp = _group addWaypoint [_lzPosition, 0];

// Once close, start the EachFrame handler to hold hover position
[_missionId, _mission, _helicopter, _hoverPosATL, _hoverHeight, _playerGroup, _lzPosition] spawn {
    params ["_missionId", "_mission", "_helicopter", "_hoverPosATL", "_hoverHeight", "_playerGroup", "_lzPosition"];

    // Wait for helicopter to get close
    waitUntil {sleep 1; _helicopter distance2D _lzPosition < 250 || isNull _helicopter};
    if (isNull _helicopter) exitWith {};

    private _hoverPosASL = AGLtoASL _hoverPosATL;

    // Transition: guide helicopter to hover position
    private _pfhArgs = [_helicopter, time, getPosASL _helicopter, _hoverPosASL, vectorDir _helicopter];

    addMissionEventHandler ["EachFrame", {
        if (isGamePaused) exitWith {};
        _thisArgs params ["_helicopter", "_t0", "_startPos", "_targetPos", "_startDir"];

        if (isNull _helicopter || {_helicopter getVariable ["vgm_missions_stabo_departed", false]}) exitWith {
            removeMissionEventHandler ["EachFrame", _thisEventHandler];
        };

        private _t = linearConversion [_t0, _t0 + 10, time, 0, 1, true];

        if (_t < 1) exitWith {
            private _targetDir = _startPos vectorFromTo _targetPos;
            _helicopter setVelocityTransformation [
                _startPos,
                _targetPos,
                velocity _helicopter,
                [0,0,0],
                _startDir,
                _targetDir,
                [0,0,1],
                [0,0,1],
                _t
            ];
        };

        // Hold at hover position
        if (diag_frameNo % 2 == 0) then {
            private _v = velocity _helicopter;
            _v set [0, 0];
            _v set [1, 0];
            _v set [2, 0];
            _helicopter setVelocity _v;
            _helicopter setPosASL _targetPos;
        };

        // Stabilize orientation
        if (diag_frameNo % 30 == 0) then {
            private _pitchBank = _helicopter call BIS_fnc_getPitchBank;
            if (count (_pitchBank select {abs _x > 10}) > 0) then {
                _helicopter setVectorUp [0,0,1];
            };
        };
    }, _pfhArgs];

    // Wait for helicopter to reach hover position and stabilize
    sleep 12;

    // Create STABO rope from helicopter belly to ground
    private _rope = ropeCreate [_helicopter, [0, 1, 0], _hoverHeight];
    _helicopter setVariable ["vgm_missions_stabo_rope", _rope];

    // Signal clients that hookup is ready
    _helicopter setVariable ["vgm_missions_stabo_hookupReady", true, true];

    // Store rope ground position for client-side proximity checks
    private _ropeGroundPos = +_lzPosition;
    _ropeGroundPos set [2, 0];
    _helicopter setVariable ["vgm_missions_stabo_ropeGroundPos", _ropeGroundPos, true];

    // Voice line: arrival (rope dropped)
    private _pilot = driver _helicopter;
    ["extraction", "arrival", false, _pilot, true] call vgm_s_fnc_voicelines_play;

    "STABO: Rope dropped, hookup ready" call vgm_g_fnc_logInfo;

    // Notify clients: rope is down, hook up!
    ["vgm_missions_gameplay_staboRopeDropped", [_missionId, _helicopter, _hoverHeight], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    // Auto-hook SOG AI squad members (server-side, they can't use hold actions)
    private _aiUnits = units _playerGroup select {alive _x && !isPlayer _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
    {
        private _hookedCount = _helicopter getVariable ["vgm_missions_stabo_hookedCount", 0];
        private _zOffset = -(_hoverHeight) + (_hookedCount * 2) + 1;

        _x disableAI "MOVE";
        _x disableAI "PATH";
        _x switchMove "AfalPercMstpSrasWlnrDnon";
        _x attachTo [_helicopter, [0, 1, _zOffset]];
        _x setVariable ["vgm_missions_stabo_hooked", true, true];
        _helicopter setVariable ["vgm_missions_stabo_hookedCount", _hookedCount + 1, true];

        format ["STABO: AI %1 auto-hooked (slot %2)", name _x, _hookedCount + 1] call vgm_g_fnc_logInfo;
    } forEach _aiUnits;

    // Wait for all alive non-unconscious players to hook up, or evacNow/evacAt trigger
    waitUntil {
        sleep 1;
        if (isNull _helicopter) exitWith {true};

        private _alivePlayers = units _playerGroup select {alive _x && isPlayer _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
        private _allHooked = _alivePlayers findIf {!(_x getVariable ["vgm_missions_stabo_hooked", false])} == -1 && _alivePlayers isNotEqualTo [];
        private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
        private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];

        _allHooked || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime)
    };

    if (isNull _helicopter) exitWith {};

    // Depart: release hover, let heli fly naturally to despawn
    _helicopter setVariable ["vgm_missions_stabo_departed", true];
    _helicopter setCaptive false;

    // Voice line: liftoff
    private _pilot = driver _helicopter;
    ["extraction", "liftoff", false, _pilot, true] call vgm_s_fnc_voicelines_play;

    ["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    format ["STABO: Lifting off for mission %1", _missionId] call vgm_g_fnc_logInfo;

    private _despawnWp = (group _helicopter) addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

    // End mission after a delay
    sleep 25;
    private _endType = ["FAILURE", "SUCCESS"] select (units _playerGroup findIf {_x getVariable ["vgm_missions_stabo_hooked", false]} > -1);
    [_missionId, _endType] call vgm_s_fnc_missions_endMission;

    // Cleanup
    waitUntil {sleep 5; isNull _helicopter || {crew _helicopter findIf {isPlayer _x} == -1}};
    if (!isNull _helicopter) then {
        // Unhook any remaining players and AI (client PFH self-removes when hooked becomes false)
        {
            if (_x getVariable ["vgm_missions_stabo_hooked", false]) then {
                _x setVariable ["vgm_missions_stabo_hooked", false, true];
                if (!isPlayer _x) then {
                    detach _x;
                    _x enableAI "MOVE";
                    _x enableAI "PATH";
                };
            };
        } forEach units _playerGroup;

        // Detach any STABO-hooked officer (server-local AI)
        private _hookedOfficer = _helicopter getVariable ["vgm_missions_stabo_hookedOfficer", objNull];
        if (!isNull _hookedOfficer) then {
            detach _hookedOfficer;
            _hookedOfficer setVariable ["vgm_snatch_stabo_hooked", false, true];
            format ["STABO: Officer detached during cleanup for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };

        sleep 25;
        {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
        deleteVehicle _helicopter;
    };

    format ["STABO: Cleanup complete for mission %1", _missionId] call vgm_g_fnc_logInfo;
};
