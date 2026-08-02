/*
    File: fn_missions_gameplay_snatch_onMissionStarted.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Handles mission start for Prisoner Snatch type. Spawns a PAVN officer
        and guards at a random site, creates tasks, and starts monitoring.
        Guard count scales with player count.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_snatch_onMissionStarted
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Snatch: Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "prisoner_snatch") exitWith {};

private _missionPublic = _mission get "public";
private _playerGroup = _missionPublic get "group";
private _targetZone = _missionPublic get "targetZone";

// Get spawned sites in the zone, prefer encampments/waystations
private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
if (_sites isEqualTo []) exitWith {
    format ["Snatch: No sites in zone for mission %1", _missionId] call vgm_g_fnc_logError;
};

// Prefer narrative-appropriate site types
private _preferredSites = _sites select {
    private _class = _x get "class";
    _class in ["encampment", "waystation", "supplyDump"]
};
if (_preferredSites isEqualTo []) then {_preferredSites = _sites};
private _targetSite = selectRandom _preferredSites;
private _sitePos = _targetSite get "pos";

// Scale guards with player count: base 2 + 1 per player beyond 2
private _playerCount = count (units _playerGroup select {alive _x && isPlayer _x});
private _guardCount = 2 + (0 max (_playerCount - 2));
_guardCount = _guardCount min 6; // cap at 6

// Spawn PAVN officer and guards
private _officerClasses = ["vn_o_men_nva_01", "vn_o_men_nva_15", "vn_o_men_nva_dc_01"];
private _guardClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06"];

private _grp = createGroup east;
_grp deleteGroupWhenEmpty true;

// Spawn officer
private _officerClass = selectRandom _officerClasses;
private _officer = _grp createUnit [_officerClass, _sitePos, [], 3, "NONE"];
_officer setVariable ["vgm_snatch_target", true, true];
_officer setVariable ["vgm_snatch_missionId", _missionId, true];

// Setup the officer's HandleDamage EH (makes him go unconscious instead of dying)
[_officer] call vgm_s_fnc_missions_gameplay_snatch_setupTarget;

// Spawn guards
private _guards = [];
for "_i" from 1 to _guardCount do {
    private _guardClass = selectRandom _guardClasses;
    private _guard = _grp createUnit [_guardClass, _sitePos, [], 10, "NONE"];
    _guards pushBack _guard;
};

// Set group to defend site
_grp setBehaviourStrong "AWARE";
_grp setCombatMode "RED";
private _wp = _grp addWaypoint [_sitePos, 0];
_wp setWaypointType "HOLD";

// Store references
private _snatchNetmap = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
[_snatchNetmap, "officer", _officer] call para_s_fnc_netmap_set;
[_snatchNetmap, "guards", _guards] call para_s_fnc_netmap_set;

// Create tasks (delayed to allow infil to complete)
[_mission, _missionId, _sitePos, _playerGroup] spawn {
    params ["_mission", "_missionId", "_sitePos", "_playerGroup"];
    sleep 10;

    // Offset the grid reference for the player (100-200m off)
    private _approxPos = _sitePos getPos [100 + random 100, random 360];
    private _gridRef = (_approxPos call BIS_fnc_posToGrid) joinString " ";

    private _parentTaskId = format ["vgm_snatch_%1", _missionId];

    [
        _playerGroup,
        _parentTaskId,
        [
            format [localize "STR_VGM_MISSIONS_SNATCH_TASK_DESCRIPTION", _gridRef],
            localize "STR_VGM_MISSIONS_SNATCH_TASK_TITLE"
        ],
        objNull,
        "ASSIGNED",
        -1,
        true,
        "attack"
    ] call BIS_fnc_taskCreate;

    // Subtask 1: Locate
    [
        _playerGroup,
        [format ["%1_locate", _parentTaskId], _parentTaskId],
        [
            format [localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_LOCATE_DESC", _gridRef],
            localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_LOCATE_TITLE"
        ],
        _approxPos,
        "ASSIGNED",
        -1,
        false,
        "search"
    ] call BIS_fnc_taskCreate;

    // Subtask 2: Incapacitate
    [
        _playerGroup,
        [format ["%1_capture", _parentTaskId], _parentTaskId],
        [
            localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_CAPTURE_DESC",
            localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_CAPTURE_TITLE"
        ],
        objNull,
        "CREATED",
        -1,
        false,
        "attack"
    ] call BIS_fnc_taskCreate;

    // Subtask 3: Extract
    [
        _playerGroup,
        [format ["%1_extract", _parentTaskId], _parentTaskId],
        [
            localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_EXTRACT_DESC",
            localize "STR_VGM_MISSIONS_SNATCH_SUBTASK_EXTRACT_TITLE"
        ],
        objNull,
        "CREATED",
        -1,
        false,
        "getin"
    ] call BIS_fnc_taskCreate;

    // Fire briefing voice line event
    ["vgm_voice_snatch_briefing", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
};

// Start monitoring script
[_missionId, _officer, _playerGroup] spawn vgm_s_fnc_missions_gameplay_snatch_monitorTarget;

format ["Snatch: Officer spawned at %1 with %2 guards for mission %3", _sitePos, _guardCount, _missionId] call vgm_g_fnc_logInfo;
