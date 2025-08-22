/*
    File: fn_missions_gameplay_extraction_doExtract.sqf
    Author: Savage Game Design
    Date: 2025-08-16
    Last Update: 2025-08-16
    Public: No

    Description:
        Do the helicopter extraction (liftoff, fly away, clean up etc) for the given mission extraction.

        ** MUST BE RUN IN SCHEDULED ENVIRONEMNT **

    Parameter(s):
        _missionId - ID of the mission [NUMBER]
        _playerGroup - [GROUP]
        _helicopter - [OBJECT]
        _helidpadLZ - [OBJECT]

    Returns:
        Nothing (scheduled)

    Example(s):
        ```
        private _helicopter = ["vn_b_air_uh1d_02_07"] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;

        private _helipad = createVehicle ["Land_HelipadEmpty_F", [0,0,0], [], 0, "NONE"];
        _helipad setPosATL (getPosATL (allPlayers select 0));

        [1, group (allPlayers select 0), _helicopter, _helipad] spawn vgm_s_fnc_missions_gameplay_extraction_doExtract;
        ```
*/

#define FADE_DURATION 5

params ["_missionId", "_playerGroup", "_helicopter", "_helipadLz"];

if (!canSuspend) exitWith {
    "Attempted to execute scheduled code in unscheduled environment" call vgm_g_fnc_logError;
    nil // return
};

//////////////////////////////////////////////////////////////////
// 0. WAIT FOR PLAYERS TO BOARD / FORCE EXTRACT
//////////////////////////////////////////////////////////////////

waitUntil {
    sleep 1;
    private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
    private _everyoneBoarded = _alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo [];
    private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
    private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];

    _everyoneBoarded || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime);
};

private _group = group _helicopter;

//////////////////////////////////////////////////////////////////
// 1. EXFIL TOWARDS BASE
//////////////////////////////////////////////////////////////////

_helicopter setVariable ["vgm_missions_extractionBoarded", true];
_helicopter flyInHeight [100, true];
_helicopter setCaptive false;

deleteVehicle _helipadLz;
_helicopter setVariable ["vgm_mission_extraction_helipad", nil];

["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
_group addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

sleep 25;  // post exfil travel time

private _playersInHelo = (units _playerGroup) select {isPlayer _x} select {_helicopter isEqualTo objectParent _x};
private _playersNotInHelo = (units _playerGroup) select {isPlayer _x} select {IsNull objectParent _x};

["OUT", FADE_DURATION, _playersInHelo] call vgm_g_fnc_missions_gameplay_extraction_fadeInOrOut;

sleep FADE_DURATION + 5;  // guarantee fade out is completed before teleporting helo

//////////////////////////////////////////////////////////////////
// 2. TELEPORT HELO
//////////////////////////////////////////////////////////////////

// TODO: USE EDITOR MARKERS
private _heloTeleportPositions = [
    [18950, 7650, 50],  // NORTH
    [18160, 7495, 50],  // MID 1
    [18180, 6260, 50],  // MID 2
    [20010, 4755, 50]   // SOUTH
];

// TODO: USE EDITOR MARKERS
private _baseLandingPositions = [
    [20000, 6582, 0],  // NORTH
    [20005, 6566, 0],  // MID 1
    [20008, 6549, 0],  // MID 2
    [20015, 6535, 0]   // SOUTH
];

// TODO: Is there a global variable for "Maximum number of missons"?
private _startIngressPos = _heloTeleportPositions select (_missionId mod 4);
private _baseLandingPos = _baseLandingPositions select (_missionId mod 4);

// delete all existing waypoints and teleport to new position
// TODO: Do we need to delete the waypoints?
for "_i" from (count waypoints _group - 1) to 0 step -1 do {deleteWaypoint [_group, _i];};
_helicopter setDir (_startIngressPos getDir _baseLandingPos);
_helicopter setPosATL _startIngressPos;

//////////////////////////////////////////////////////////////////
// 3. INGRESS TO BASE
//////////////////////////////////////////////////////////////////

private _helipadBase = createVehicle [["Land_HelipadEmpty_F", "Land_HelipadCircle_F"] select is3DENPreview, [0,0,0], [], 0, "NONE"];
_helipadBase setPosATL _baseLandingPos;
_helicopter setVariable ["vgm_mission_extraction_helipad", _helipadBase];

// TODO: This is bugged for some reason?!
private _wpPos = _baseLandingPos getPos [100, _startIngressPos getDir _baseLandingPos];
private _landWp = _group addWaypoint [_wpPos, 0];

_landWp setWaypointStatements ["true", toString {
    if (!isServer) exitWith {};
    [vehicle this] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
}];

// give helo a few seconds to start flying properly to avoid any jank
// once it is proceeding, fade in for players in helo and fade out abandoned players in the mission area.
// abandoned players will be faded back in during missionEnd,
// disable sim and stick abandoned players in debug to make sure they don't take damage

sleep FADE_DURATION;
["IN", FADE_DURATION, _playersInHelo] call vgm_g_fnc_missions_gameplay_extraction_fadeInOrOut;
["OUT", FADE_DURATION, _playersNotInHelo] call vgm_g_fnc_missions_gameplay_extraction_fadeInOrOut;
sleep FADE_DURATION;
_playersNotInHelo apply {
    _x enableSimulationGlobal true;
    _x setPosATL [0, 0, 0];
};

// dismount players once helo is on the invisible helipad or players have ejected from the helo.
// (all players ejecting here will cause a hardlocked and unrecoverable mission outcome!)
waitUntil {sleep 1; (_helicopter distance _helipadBase) < 1 || crew _helicopter findIf {isPlayer _x} == -1};
units _playerGroup select {vehicle _x isNotEqualTo _x} apply {moveOut _x};

//////////////////////////////////////////////////////////////////
// 4. PLAYER DEBRIEF & HELO / HELIPAD DESPAWN
//////////////////////////////////////////////////////////////////

// Once players are no longer in helo debrief players via `missionEnd` screen and 
// make chopper fly away to despawn out of sight

waitUntil {sleep 1; crew _helicopter findIf {isPlayer _x} == -1};
_playersNotInHelo apply {_x enableSimulationGlobal true};
[_missionId] call vgm_s_fnc_missions_endMission;
// bring back any abandoned players
["IN", 0, _playersNotInHelo] call vgm_g_fnc_missions_gameplay_extraction_fadeInOrOut;

_helicopter flyInHeight [100, true];
_helicopter setCaptive true;

for "_i" from (count waypoints _group - 1) to 0 step -1 do {deleteWaypoint [_group, _i];};
_group addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

sleep 45;  // time until safely out of view / earshot

{_helicopter deleteVehicleCrew _x} forEach units _helicopter;
deleteVehicle _helicopter;
deleteVehicle _helipadBase;

