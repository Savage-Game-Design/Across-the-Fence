/*
    File: fn_compromisedLz_triggerAmbush.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Spawned monitor that watches for ambush trigger conditions after
        insertion at a compromised LZ. NVA engage when:
        1. Any player gets within detection range of any NVA defender, OR
        2. Any player moves beyond 25m from LZ center (leaving the LZ), OR
        3. Any player fires a weapon near the LZ
        Whichever comes first.

    Parameter(s):
        _lzPosition   - Center position of the LZ [ARRAY]
        _defenderData - Hashmap from spawnDefenders [HASHMAP]
        _missionId    - ID of the mission [STRING/NUMBER]

    Returns:
        Nothing (runs as spawned script)

    Example(s):
        [_lzPos, _defenderData, _missionId] spawn vgm_s_fnc_compromisedLz_triggerAmbush;
*/

params ["_lzPosition", "_defenderData", "_missionId"];

private _group = _defenderData get "group";
private _units = _defenderData get "units";

// Wait until the mission's infil helicopter has landed and players are on the ground
// (give 15 seconds after landing for players to orient)
sleep 15;

private _detectionRange = vgm_s_compromisedLz_detectionRange;
private _leavingRange = vgm_s_compromisedLz_leavingRange;

// Monitor loop
waitUntil {
    sleep 0.5;

    // Bail if all defenders are dead or group deleted
    if (isNull _group || {{alive _x} count _units == 0}) exitWith {true};

    private _aliveDefenders = _units select {alive _x};
    private _allPlayers = allPlayers select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};

    private _triggered = false;

    // Condition 1: Any player within detection range of any defender
    {
        private _player = _x;
        {
            if (_player distance _x < _detectionRange) exitWith {
                _triggered = true;
            };
        } forEach _aliveDefenders;
        if (_triggered) exitWith {};
    } forEach _allPlayers;

    // Condition 2: Any player moved beyond leaving range from LZ center
    if (!_triggered) then {
        {
            if (_x distance2D _lzPosition > _leavingRange) exitWith {
                _triggered = true;
            };
        } forEach _allPlayers;
    };

    // Condition 3: Someone fired near the NVA defenders
    if (!_triggered && {_defenderData getOrDefault ["firedNear", false]}) then {
        _triggered = true;
    };

    _triggered
};

// Check if defenders are still alive before triggering
private _aliveDefenders = _units select {alive _x};
if (_aliveDefenders isEqualTo [] || isNull _group) exitWith {
    {deleteVehicle _x} forEach (_defenderData getOrDefault ["bushes", []]);
    "Compromised LZ: All defenders dead before ambush triggered" call vgm_g_fnc_logInfo;
};

// Already triggered by something else (e.g., extraction cleared them)
if (_defenderData get "ambushTriggered") exitWith {};

// TRIGGER THE AMBUSH
_defenderData set ["ambushTriggered", true];

// Prevent virtual squad system from despawning this group during combat
private _squad = _defenderData getOrDefault ["squad", createHashMap];
if (!(_squad isEqualTo createHashMap)) then {
    _squad set ["deleteOnDespawn", true];
};

// Make group hostile
_group setBehaviourStrong "COMBAT";
_group setCombatMode "RED";

// Delete concealment bushes
{deleteVehicle _x} forEach (_defenderData getOrDefault ["bushes", []]);
_defenderData set ["bushes", []];

// Reveal units: restore AI, visibility, and let them fight
{
    _x setCaptive false;
    _x enableAI "MOVE";
    _x enableAI "TARGET";
    _x enableAI "AUTOTARGET";
    _x setUnitTrait ["camouflageCoef", 1];
    _x setUnitPos "AUTO";
} forEach _aliveDefenders;

// Give them SAD waypoint on the LZ
private _wp = _group addWaypoint [_lzPosition, 20];
_wp setWaypointType "SAD";

format ["Compromised LZ: Ambush triggered at %1 for mission %2 — %3 defenders engaging",
    _lzPosition, _missionId, count _aliveDefenders] call vgm_g_fnc_logInfo;
