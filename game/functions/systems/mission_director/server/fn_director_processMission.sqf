/*
    File: fn_director_processMission.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2025-08-30
    Public: No

    Description:
        Runs periodically to direct a specific mission.

    Parameter(s):
        _mission - Mission to evaluate and update [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_processMission;
 */

params ["_mission"];

private _publicMission = _mission get "public";
private _directorData = _mission get "director";

if (_publicMission get "status" == "FINISHED") exitWith {};

private _missionPlayers = keys (_mission get "machineIds") apply { getUserInfo _x # 10 };

private _alertness = _directorData get "alertness";

[format ["Mission=%1, Alertness=%2", _publicMission get "id", _alertness]] call vgm_g_fnc_logInfo;

//////////////
// Trackers //
//////////////

private _timeSinceLastTracker = serverTime - (_directorData get "lastTrackerSent");
private _currentTrackerDelay = linearConversion [
        0, vgm_s_director_max_alertness,
        _alertness,
        vgm_s_director_max_time_between_trackers_secs, vgm_s_director_min_time_between_trackers_secs,
        true
];
private _randomExtraTime = random 120;

// Spawn a new tracker!
if (
       _alertness > vgm_s_director_tracker_spawn_alertness_threshold
    && _timeSinceLastTracker > (_currentTrackerDelay + _randomExtraTime)
) then {
    [format ["Attempting to send new tracker on mission %1", _publicMission get "id"]] call vgm_g_fnc_logInfo;
    private _newTrackerSquad = [_mission, _missionPlayers] call vgm_s_fnc_director_spawnTracker;

    if (isNil "_newTrackerSquad") exitWith {
        [format ["Failed to spawn tracker on mission %1", _publicMission get "id"]] call vgm_g_fnc_logInfo;
    };

    _directorData set ["lastTrackerSent", serverTime];
};

////////////////////
// Reinforcements //
////////////////////

{
    [_directorData, _x] call vgm_s_fnc_director_deleteEngagementIfEnded;
} forEach values (_directorData get "playerEngagements");

private _reinforcementCheckFrequencyRangeSecs = _directorData get "reinforcementCheckFrequencyRangeSecs";
private _reinforcementCheckFrequencySecs = linearConversion [
    0, vgm_s_director_max_alertness,
    _alertness,
    _reinforcementCheckFrequencyRangeSecs # 0, _reinforcementCheckFrequencyRangeSecs # 1,
    true
];

private _minTimeBetweenReinforcementsRangeSecs = (_directorData get "minTimeBetweenReinforcementsRangeSecs");
private _minTimeBetweenReinforcementsSecs = linearConversion [
    0, vgm_s_director_max_alertness,
    _alertness,
    _minTimeBetweenReinforcementsRangeSecs # 0, _minTimeBetweenReinforcementsRangeSecs # 1,
    true
];

if (count (_directorData get "playerEngagements") > 0) then {
    [format [
        "[Reinforcements - Mission: %1] Reinforcement checks running | Check frequency = %2 | Min time between reinforcements = %3 |",
        _publicMission get "id",
        _reinforcementCheckFrequencySecs,
        _minTimeBetweenReinforcementsSecs
    ]] call vgm_g_fnc_logDebug;
};

{
    private _engagement = _x;
    // Run the reinforcment check less often than the director ticks.
    // Importantly, this controls the initial reinforcment delay for new engagements!
    private _checkedRecently = serverTime - (_engagement get "lastReinforcementCheck") < _reinforcementCheckFrequencySecs;
    if (_checkedRecently) then {
        continue;
    };

    _engagement set ["lastReinforcementCheck", serverTime];
    private _engagementPlayerHash = _engagement get "playerHash";
    // Technically this always grows (nothing removes players from here), but shouldn't be a problem as directorData is deleted on mission end.
    private _lastReinforcementSent = _directorData get "lastReinforcementSentPerPlayer" getOrDefault [_engagementPlayerHash, -9999];
    private _reinforcementsSentRecently = (serverTime - _lastReinforcementSent) < _minTimeBetweenReinforcementsSecs;

    // Avoid spamming players with squads, no matter what.
    if (_reinforcementsSentRecently) then {
        [format ["[Reinforcements - Mission: %1, Player: %2] Skipping reinforce - squad spawned recently", _publicMission get "id", _engagement get "player"]] call vgm_g_fnc_logDebug;
        continue;
    };

    // Roll the dice on spawning reinforcements. Adds a little variation, and provides an extra tuning option.
    if (random 1 > (_directorData get "reinforcementChance")) then {
        [format ["[Reinforcements - Mission: %1, Player: %2] Skipping reinforce - random roll failed", _publicMission get "id", _engagement get "player"]] call vgm_g_fnc_logDebug;
        continue;
    };

    [format ["[Reinforcements - Mission: %1, Player: %2] Attempting to create squad", _publicMission get "id", _engagement get "player"]] call vgm_g_fnc_logInfo;
    private _squad = [_mission, _engagement get "player"] call vgm_s_fnc_director_spawnReinforcements;

    if (isNil "_squad") then {
        [format ["[Reinforcements - Mission: %1, Player: %2] Failed to create squad", _publicMission get "id", _engagement get "player"]] call vgm_g_fnc_logInfo;
        continue;
    };

    _directorData get "lastReinforcementSentPerPlayer" set [_engagementPlayerHash, serverTime];

} forEach values (_directorData get "playerEngagements");
