/*
    File: fn_director_attemptReinforcements.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-10-25
    Public: Yes

    Description:
        Spawn enemy reinforcements, provided all balancing checks pass.

    Parameter(s):
        _mission - Mission the player is on [HASHMAP]
        _players - Players to attack with the reinforcements [OBJECT]

    Returns:
        The squad created, or nil if a squad couldn't be spawned. [GROUP]

    Example(s):
        [_mission, _players] call vgm_s_fnc_director_attemptReinforcements;
 */


params ["_mission", "_players", ["_reason", "?"]];

[format [
    "[Reinforcements - Mission: %1, Players: %2] Attempting to spawn reinforcements | Reason: %3 |",
    _publicMission get "id",
    _players,
    _reason
]] call vgm_g_fnc_logDebug;

private _publicMission = _mission get "public";
private _directorData = _mission get "director";

private _minTimeBetweenReinforcementsRangeSecs = (_directorData get "minTimeBetweenReinforcementsRangeSecs");
private _minTimeBetweenReinforcementsSecs = linearConversion [
    0, vgm_s_director_max_alertness,
    (_directorData get "alertness"),
    _minTimeBetweenReinforcementsRangeSecs # 0, _minTimeBetweenReinforcementsRangeSecs # 1,
    true
];

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
private _timeSinceReinforcements = serverTime - _averageLastReinforcementTime;
private _reinforcementsSentRecently = _timeSinceReinforcements < _minTimeBetweenReinforcementsSecs;

// Avoid spamming players with squads, no matter what.
if (_reinforcementsSentRecently) then {
    [format [
        "[Reinforcements - Mission: %1, Players: %2] Skipping reinforce - squad spawned recently (%3s ago) | Minimum delay: %4s |",
        _publicMission get "id",
        _players,
        floor _timeSinceReinforcements,
        floor _minTimeBetweenReinforcementsSecs
    ]] call vgm_g_fnc_logDebug;
    continue;
};

// Roll the dice on spawning reinforcements. Adds a little variation, and provides an extra tuning option.
if (random 1 > (_directorData get "reinforcementChance")) then {
    [format ["[Reinforcements - Mission: %1, Players: %2] Skipping reinforce - random roll failed", _publicMission get "id", _players]] call vgm_g_fnc_logDebug;
    continue;
};

private _reinforcementType = keys (_directorData get "reinforcementTypeChances") selectRandomWeighted values (_directorData get "reinforcementTypeChances");

private _squad = [_mission, _players, _reinforcementType] call vgm_s_fnc_director_spawnReinforcements;

if (isNil "_squad") then {
    [format ["[Reinforcements - Mission: %1, Players: %2] Failed to create squad", _publicMission get "id", _players]] call vgm_g_fnc_logInfo;
    continue;
};

{ _directorData get "lastReinforcementSentPerPlayer" set [hashValue _x, serverTime] } forEach _players;
