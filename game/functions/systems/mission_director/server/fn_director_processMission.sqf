/*
    File: fn_director_processMission.sqf
    Author:
    Date: 2023-09-29
    Last Update: 2025-09-19
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

private _playerEngagements = _directorData get "playerEngagements";

if (count _playerEngagements > 0) then {
    [format [
        "[Reinforcements - Mission: %1] Reinforcement checks running | Check frequency = %2 | Min time between reinforcements = %3 |",
        _publicMission get "id",
        _reinforcementCheckFrequencySecs,
        _minTimeBetweenReinforcementsSecs
    ]] call vgm_g_fnc_logDebug;
};

// Cluster players that are close to each other.
private _playerClusters = [_missionPlayers, 50] call para_g_fnc_build_unit_clusters;

{
    private _players = _x;
    private _engagements = _players apply { _playerEngagements get hashValue _x } select { !isNil "_x" };
    // Run the reinforcment check less often than the director ticks.
    // Importantly, this controls the initial reinforcment delay for new engagements!
    // Use the oldest check time among players - that's the least forgiving, as new players join with this at serverTime.
    // Other values allow new players joining the cluster to increase reinforcement delay.
    // This way, an engaged player joining a cluster will be bringing trouble with them too - which feels thematic.
    private _lastReinforcementCheck = selectMin ( [serverTime] + (_engagements apply { _x get "lastReinforcementCheck" }) );
    private _checkedRecently = serverTime - _lastReinforcementCheck < _reinforcementCheckFrequencySecs;
    if (_checkedRecently) then {
        continue;
    };
    { _x set ["lastReinforcementCheck", serverTime] } forEach _engagements;

    // Technically this always grows (nothing removes players from here), but shouldn't be a problem as directorData is deleted on mission end.
    // TODO - Time gating this might not be the best approach now we're clustering. I'm going to gate for now, but we might want to use different data to balance.
    // E.g. monitoring the intensity of the firefight, or deliberately giving players a break.
    private _lastReinforcementSentTimes = _players apply {
        (_directorData get "lastReinforcementSentPerPlayer" getOrDefault [hashValue _x, -9999])
            // Cap it so averaging provides good values when players join / leave the cluster
            max (serverTime - 1.5 * _minTimeBetweenReinforcementsSecs)
    };
    // Take the average of when the last reinforcements were sent - this means new players in the cluster impact reinforcements, but don't immediately trigger something.
    private _averageLastReinforcementTime = (_lastReinforcementSentTimes call vgm_g_fnc_fastSum) / count _lastReinforcementSentTimes;
    private _reinforcementsSentRecently = (serverTime - _averageLastReinforcementTime) < _minTimeBetweenReinforcementsSecs;

    // Avoid spamming players with squads, no matter what.
    if (_reinforcementsSentRecently) then {
        [format ["[Reinforcements - Mission: %1, Players: %2] Skipping reinforce - squad spawned recently", _publicMission get "id", _players]] call vgm_g_fnc_logDebug;
        continue;
    };

    // Roll the dice on spawning reinforcements. Adds a little variation, and provides an extra tuning option.
    if (random 1 > (_directorData get "reinforcementChance")) then {
        [format ["[Reinforcements - Mission: %1, Players: %2] Skipping reinforce - random roll failed", _publicMission get "id", _players]] call vgm_g_fnc_logDebug;
        continue;
    };

    private _squad = [_mission, _players] call vgm_s_fnc_director_spawnReinforcements;

    if (isNil "_squad") then {
        [format ["[Reinforcements - Mission: %1, Players: %2] Failed to create squad", _publicMission get "id", _players]] call vgm_g_fnc_logInfo;
        continue;
    };

    { _directorData get "lastReinforcementSentPerPlayer" set [hashValue _x, serverTime] } forEach _players;
} forEach _playerClusters;
