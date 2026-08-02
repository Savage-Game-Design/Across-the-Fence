/*
    File: fn_director_spawnTracker.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-01-16
    Public: Yes

    Description:
        Spawns a new tracking unit.

    Parameter(s):


    Returns:
        The squad created, or nil if a squad couldn't be spawned. [GROUP]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#define MIN_DISTANCE_BETWEEN_TRACKS 100
#define TRACKER_HARD_BLOCK 150
#define TRACKER_SOFT_BLOCK 400

params ["_mission", "_players"];

private _missionId = _mission get "public" get "id";
private _trackPositions = [_missionId] call vgm_g_fnc_tracking_getTrackPositions;

// Needs to be impossible far away so the first distance calculation works.
private _lastTrackPosition = [999999, 999999, 999999];

// Trackers use tighter spawn radii than normal squads so they spawn on
// recent tracks close to the players, well inside the virtsquad despawn range.
private _spawnPos = {
    if (_x distance2D _lastTrackPosition < MIN_DISTANCE_BETWEEN_TRACKS) then { continue };
    private _isValid = ([_x, _players, TRACKER_SOFT_BLOCK, TRACKER_HARD_BLOCK] call para_g_fnc_spawning_is_valid_position) # 0;
    if (_isValid) exitWith {
        _x
    };
} forEachReversed _trackPositions;

if (isNil "_spawnPos") exitWith { nil };

private _unitCount = count _players + 2;

private _template = [vgm_s_director_tracker_classes select [0, _unitCount], _spawnPos, _missionId] call vgm_s_fnc_director_getEnemySquadTemplate;

// Tag as tracker team so the tracking behaviour tree decorator allows trail-following
(_template get "groupVars") set ["vgm_isTrackerTeam", [true, true]];
// Delete on despawn so a fresh tracker spawns on closer tracks instead of
// re-virtualising at the old (now out-of-range) position.
_template set ["deleteOnDespawn", true];

private _squad = [_template] call vgm_s_fnc_virtsquad_create;

// Voice line: COVEY tracker warning (delayed 30-60s, RTO required)
[30 + random 30, "tracker", "warning", true] call vgm_s_fnc_voicelines_playDelayed;

_squad
