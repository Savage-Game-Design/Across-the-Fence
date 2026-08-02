/*
    File: fn_missions_gameplay_infil_startInfil.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns a UH-1D helicopter 3000m from the LZ, loads all players into cargo,
        flies to the LZ, lands via scriptedLand, ejects passengers, and fires the
        deploy event. Includes a 10% LZ Watcher chance that triggers an immediate
        tracker dispatch.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]
        _mission   - Mission hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_missionId, _mission] call vgm_s_fnc_missions_gameplay_infil_startInfil
 */

params ["_missionId", "_mission"];

private _missionPublic = _mission get "public";
private _playerGroup = _missionPublic get "group";
private _startPosASL = _missionPublic get "startPosASL";
private _startPosATL = ASLToATL _startPosASL;

private _class = "vn_b_air_uh1d_02_07";
private _originPos = markerPos "vgm_shared_hub";
private _distance = 3000;

// Spawn the helicopter coming from the direction of the hub
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;

private _spawnPos = _startPosATL getPos [_distance, _startPosATL getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;
_helicopter setDir (_spawnPos getDir _startPosATL);

// Force NOE altitude during transit. scriptedLand uses a transit waypoint
// that respects this, then switches to landAt when close to the LZ.
_helicopter flyInHeight [25, true];

// Store helicopter reference on the group (broadcast so clients can read it)
_playerGroup setVariable ["vgm_missions_infil_helicopter", _helicopter, true];


// Boarding is handled client-side in finishDeploy_infil (moveInCargo requires
// the unit to be local, which on a dedicated server means each player's client).
// Pass the helicopter directly — relying on (group player) getVariable fails
// if joinSilent didn't complete for a player (known Arma issue).
[_helicopter] remoteExecCall ["vgm_c_fnc_missions_finishDeploy_infil", values (_mission get "machineIds")];

// Create helipad at LZ for scriptedLand
private _safeLzPositionATL = _startPosATL findEmptyPosition [0, 100, _class];
if (_safeLzPositionATL isEqualTo []) then {
    _safeLzPositionATL = _startPosATL;
};
_safeLzPositionATL set [2, 0];

private _helipad = createVehicle ["Land_vn_helipadempty_f", [0,0,0], [], 0, "NONE"];
_helipad setPosATL _safeLzPositionATL;

// Tell AI to fly to the LZ and land — landAt handles the entire approach
private _group = group _helicopter;
_helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];
[_helicopter] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;

// Check if insertion LZ is compromised (for voice line selection in spawned block)
// Use proximity check instead of hash match since startPosATL may differ slightly
// from the LZ position stored during occupyLzs (ASL/ATL conversion)
private _insertionLzCompromised = false;
private _insertionLzDefKey = "";
{
    private _defData = _y;
    if (_defData get "missionId" isEqualTo _missionId &&
        {(_defData get "lzPosition") distance2D _startPosATL < 50}) exitWith {
        _insertionLzCompromised = true;
        _insertionLzDefKey = _x;
    };
} forEach vgm_s_compromisedLz_occupiedLzs;

// Spawned script handles post-landing: eject, deploy event, cleanup
[_missionId, _mission, _helicopter, _helipad, _playerGroup, _group, _startPosATL, _insertionLzCompromised] spawn {
    params ["_missionId", "_mission", "_helicopter", "_helipad", "_playerGroup", "_group", "_lzPos", "_isCompromised"];

    // Voice line: LZ approach (~1000m out) — hot LZ line if compromised
    private _approachPlayed = false;
    waitUntil {
        sleep 0.5;
        if (!_approachPlayed && {_helicopter distance2D _lzPos < 1000}) then {
            private _pilot = driver _helicopter;
            if (_isCompromised) then {
                ["insertion", "lz_hot", false, _pilot] call vgm_s_fnc_voicelines_play;
            } else {
                ["insertion", "lz_approach", false, _pilot] call vgm_s_fnc_voicelines_play;
            };
            _approachPlayed = true;
        };
        _helicopter getVariable ["vgm_missions_extractionLanded", false]
    };

    // Notify clients: approaching LZ
    ["vgm_missions_gameplay_infilLanded", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
    "Infil helicopter landed at LZ" call vgm_g_fnc_logInfo;

    // 5s on the ground — rotor wash settles and players can engage targets before forced eject
    sleep 5;

    // Force-eject all passengers (players and AI squad members)
    private _allPassengers = units _playerGroup select {alive _x};
    {
        if (_x in _helicopter) then {
            private _safePos = (getPosATL _helicopter) findEmptyPosition [3, 30, "CAManBase"];
            if (_safePos isEqualTo []) then {
                _safePos = getPosATL _helicopter;
            };
            moveOut _x;
            _x setPos _safePos;
        };
    } forEach _allPassengers;

    // Place pickup marker at landing position, visible to all players
    private _lzMarkerName = format ["vgm_lz_%1", _missionId];
    createMarker [_lzMarkerName, getPosATL _helicopter];
    _lzMarkerName setMarkerType "hd_pickup";
    _lzMarkerName setMarkerColor "ColorBLUFOR";
    _lzMarkerName setMarkerText "LZ";
    _mission set ["vgm_s_lzMarker", _lzMarkerName];

    // Fire the deploy event on clients (triggers skills, tutorials, etc.)
    // Use Paradigm event targeting so each client fires deploy_local with their own mission data
    ["vgm_missions_gameplay_infilDeployed", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    // Stop the EachFrame hover handler
    _helicopter setVariable ["vgm_missions_extractionBoarded", true];

    // ---- Compromised LZ check (mutually exclusive with LZ Watcher) ----
    // Proximity-based lookup: find any compromised LZ within 50m of our landing pos
    private _lzDefenderData = nil;
    {
        private _defData = _y;
        if (_defData get "missionId" isEqualTo _missionId &&
            {(_defData get "lzPosition") distance2D _lzPos < 50}) exitWith {
            _lzDefenderData = _defData;
        };
    } forEach vgm_s_compromisedLz_occupiedLzs;

    if (!isNil "_lzDefenderData") then {
        // LZ is compromised — start ambush trigger monitor
        [_lzPos, _lzDefenderData, _missionId] spawn vgm_s_fnc_compromisedLz_triggerAmbush;

        // Raise alertness to 15 (enemy was watching)
        private _directorData = _mission getOrDefault ["director", createHashMap];
        if (!isNil "_directorData") then {
            private _currentAlertness = _directorData getOrDefault ["alertness", 0];
            if (_currentAlertness < 15) then {
                _directorData set ["alertness", 15];
                _directorData set ["lastAlertnessEventTime", serverTime];
            };
        };

        format ["Compromised LZ: Ambush set at insertion LZ %1 for mission %2", _lzPos, _missionId] call vgm_g_fnc_logInfo;
    } else {
        // ---- LZ Watcher: 10% chance enemy spotted the helicopter ----
        if (random 1 < 0.1) then {
            private _directorData = _mission get "directorData";
            if (!isNil "_directorData") then {
                _directorData set ["alertness", 6];
                _directorData set ["lastAlertnessEventTime", serverTime];

                // Delayed tracker dispatch -- give players 30-120s to move off the LZ
                [_mission, _playerGroup, _directorData] spawn {
                    params ["_mission", "_playerGroup", "_directorData"];
                    private _delay = 30 + random 90;
                    sleep _delay;
                    private _missionPlayers = units _playerGroup select {alive _x && isPlayer _x};
                    if (_missionPlayers isEqualTo []) exitWith {};
                    [_mission, _missionPlayers] call vgm_s_fnc_director_spawnTracker;
                    _directorData set ["lastTrackerSent", serverTime];
                    "LZ Watcher: Tracker team dispatched to LZ trail" call vgm_g_fnc_logInfo;
                };
            };
        };
    };

    // Helicopter departs
    _helicopter flyInHeight [100, true];
    _helicopter setCaptive false;
    private _despawnWp = _group addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

    // Cleanup after departure
    sleep 60;
    waitUntil {sleep 5; crew _helicopter findIf {isPlayer _x} == -1};
    {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
    deleteVehicle _helicopter;
    deleteVehicle _helipad;
    format ["Infil helicopter cleaned up for mission %1", _missionId] call vgm_g_fnc_logInfo;
};
