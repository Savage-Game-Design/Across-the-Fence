/*
    File: fn_missions_gameplay_hatchet_spawnCounterattack.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Spawns extraction counterattack wave when the "secure" objective completes.
        Two elements:
        1. Assault wave: 2 squads (4-6 units each, scaling with player count)
           spawning 250-350m away, pushing toward the RT position with SAD waypoints.
        2. LZ ambush: 1 squad (3-5 units) spawning 80-120m from the RT position
           to threaten the extraction helicopter landing zone.

    Parameter(s):
        _reconPos       - Position of the recon team [ARRAY]
        _playerGroup    - The player group [GROUP]
        _reconTeam      - Array of recon team units [ARRAY]
        _spawnedEnemies - Existing spawned PAVN units [ARRAY]
        _hatchetNetmap  - Hatchet system netmap [HASHMAP]
        _playerCount    - Number of alive players [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_reconPos, _playerGroup, _reconTeam, _spawnedEnemies, _hatchetNetmap, _playerCount]
            spawn vgm_s_fnc_missions_gameplay_hatchet_spawnCounterattack;
 */

params ["_reconPos", "_playerGroup", "_reconTeam", "_spawnedEnemies", "_hatchetNetmap", "_playerCount"];

private _enemyClasses = [
    "vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04",
    "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07",
    "vn_o_men_nva_10"
];

private _counterattackUnits = [];

// === Assault wave: 2 squads pushing from distance ===
for "_i" from 1 to 2 do {
    private _assaultGrp = createGroup east;
    _assaultGrp deleteGroupWhenEmpty true;

    // Squad size: 4 base, +1 per 2 players, capped at 6
    private _squadSize = 4 + floor (_playerCount / 2);
    _squadSize = _squadSize min 6;

    // Spawn 250-350m away from RT position, spread around
    private _dir = (_i * 180) + random 60 - 30; // Roughly opposite sides
    private _spawnPos = _reconPos getPos [250 + random 100, _dir];

    for "_j" from 1 to _squadSize do {
        private _unit = _assaultGrp createUnit [selectRandom _enemyClasses, _spawnPos, [], 10, "NONE"];
        _counterattackUnits pushBack _unit;
    };

    _assaultGrp setBehaviourStrong "COMBAT";
    _assaultGrp setCombatMode "RED";
    private _wp = _assaultGrp addWaypoint [_reconPos, 30];
    _wp setWaypointType "SAD";
};

// === LZ ambush: 1 squad near the RT position ===
private _ambushGrp = createGroup east;
_ambushGrp deleteGroupWhenEmpty true;

// Squad size: 3 base, +1 per 3 players, capped at 5
private _ambushSize = 3 + floor (_playerCount / 3);
_ambushSize = _ambushSize min 5;

// Spawn 80-120m from RT, random direction
private _ambushPos = _reconPos getPos [80 + random 40, random 360];

for "_j" from 1 to _ambushSize do {
    private _unit = _ambushGrp createUnit [selectRandom _enemyClasses, _ambushPos, [], 10, "NONE"];
    _counterattackUnits pushBack _unit;
};

_ambushGrp setBehaviourStrong "COMBAT";
_ambushGrp setCombatMode "RED";
private _ambushWp = _ambushGrp addWaypoint [_reconPos, 20];
_ambushWp setWaypointType "SAD";

// Store counterattack units in netmap for tracking
[_hatchetNetmap, "counterattackUnits", _counterattackUnits] call para_s_fnc_netmap_set;

format ["Hatchet: Counterattack spawned — %1 units (2 assault + 1 ambush) around %2", count _counterattackUnits, _reconPos] call vgm_g_fnc_logInfo;
