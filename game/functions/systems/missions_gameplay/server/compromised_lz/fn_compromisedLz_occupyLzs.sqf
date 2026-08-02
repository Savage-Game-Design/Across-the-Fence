/*
    File: fn_compromisedLz_occupyLzs.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Rolls compromise chance for each LZ in a mission's zone and registers
        virtual squads at those that fail the check. Squads spawn/despawn
        based on player proximity (500m/700m) via the virtual squad system.
        Chance scales with mission director alertness.
        LZs with players within 200m are skipped.

    Parameter(s):
        _missionId - ID of the mission [STRING/NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_compromisedLz_occupyLzs;
*/

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Compromised LZ: Mission %1 not found", _missionId] call vgm_g_fnc_logWarning;
};

private _missionPublic = _mission get "public";
private _targetBox = _missionPublic get "targetZone";
private _playerGroup = _missionPublic get "group";

// Get all LZs in the zone
private _lzs = [_targetBox] call vgm_g_fnc_missions_zones_getLzs;
if (_lzs isEqualTo []) exitWith {
    "Compromised LZ: No LZs in zone" call vgm_g_fnc_logInfo;
};

// Calculate compromise chance based on alertness
private _director = _mission getOrDefault ["director", createHashMap];
private _alertness = _director getOrDefault ["alertness", 0];
private _alertnessFraction = _alertness / vgm_s_director_max_alertness;
private _compromiseChance = vgm_s_compromisedLz_baseChance
    + (vgm_s_compromisedLz_alertnessScaling * _alertnessFraction);

// Player count for scaling defender squad size
private _playerCount = {alive _x && isPlayer _x} count units _playerGroup;

// Squad size: 4 base + 1 per 3 players, max 8
private _squadSize = (4 + floor (_playerCount / 3)) min 8;

// Half MG, half rifle (round up for MG if odd)
private _mgCount = ceil (_squadSize / 2);
private _rifleCount = _squadSize - _mgCount;

private _compromisedCount = 0;

{
    private _lzPos = _x;

    // Skip LZs with players nearby
    private _tooCloseToPlayer = allPlayers findIf {
        alive _x && {_x distance2D _lzPos < vgm_s_compromisedLz_playerSafeRadius}
    } > -1;

    if (_tooCloseToPlayer) then {
        format ["Compromised LZ: Skipping LZ at %1 — player nearby", _lzPos] call vgm_g_fnc_logDebug;
    } else {
        // Roll the dice
        if (random 1 < _compromiseChance) then {
            // Build composition: MG classes then rifle classes
            private _composition = [];
            for "_i" from 1 to _mgCount do {
                _composition pushBack (selectRandom vgm_s_compromisedLz_mgClasses);
            };
            for "_i" from 1 to _rifleCount do {
                _composition pushBack (selectRandom vgm_s_compromisedLz_rifleClasses);
            };

            // Offset spawn position ~50m from LZ center so AI don't sit on the landing pad
            private _spawnPos = _lzPos getPos [40 + random 20, random 360];
            _spawnPos set [2, 0];

            // Create virtual squad template
            private _template = createHashMapFromArray [
                ["pos", _spawnPos],
                ["composition", _composition],
                ["sizeRange", [_squadSize, _squadSize]],
                ["groupVars", createHashMap],
                ["side", east],
                ["deleteOnDespawn", false],
                ["missionId", _missionId],
                ["lzPosition", _lzPos],
                ["onSpawn", vgm_s_fnc_compromisedLz_spawnDefenders]
            ];

            private _squad = [_template] call vgm_s_fnc_virtsquad_create;

            // Track the squad for cleanup
            private _key = format ["%1_%2", _missionId, hashValue _lzPos];
            vgm_s_compromisedLz_occupiedLzs set [_key, _squad];

            _compromisedCount = _compromisedCount + 1;
        };
    };
} forEach _lzs;

format ["Compromised LZ: %1 of %2 LZs compromised for mission %3 (chance: %4%%)",
    _compromisedCount, count _lzs, _missionId,
    round (_compromiseChance * 100)] call vgm_g_fnc_logInfo;
