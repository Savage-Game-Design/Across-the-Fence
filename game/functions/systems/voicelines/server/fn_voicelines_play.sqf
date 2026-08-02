/*
    File: fn_voicelines_play.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Main API for playing voice lines. Picks a random line from the specified
        pool, enforces global and per-category cooldowns, checks RTO requirement,
        and broadcasts via sideRadio to all BLUFOR players.

        Speaker unit:
        - If _speakerUnit is provided (e.g. helicopter pilot), that unit speaks
        - Otherwise, uses the invisible COVEY unit (vgm_s_voicelines_coveyUnit)

    Parameter(s):
        _category     - Voice line category (e.g. "insertion", "combat") [STRING]
        _subcategory  - Subcategory (e.g. "lz_approach", "prairie_fire") [STRING]
        _requiresRTO  - Whether this line requires an RTO in the team [BOOLEAN]
        _speakerUnit  - (Optional) Unit to speak the line [OBJECT, default objNull]
        _priority     - (Optional) Priority override - bypasses category cooldown,
                        uses reduced 5s global cooldown [BOOLEAN, default false]

    Returns:
        true if line was played, false if blocked by cooldown/RTO check [BOOLEAN]

    Example(s):
        ["insertion", "lz_approach", false] call vgm_s_fnc_voicelines_play;
        ["combat", "prairie_fire", true, objNull, true] call vgm_s_fnc_voicelines_play;
        ["extraction", "arrival", false, _heliPilot] call vgm_s_fnc_voicelines_play;
*/

if (!isServer) exitWith {false};

params ["_category", "_subcategory", ["_requiresRTO", false], ["_speakerUnit", objNull], ["_priority", false]];

// ---- RTO Check ----
if (_requiresRTO && {(allPlayers select {_x getUnitTrait "vn_artillery"}) isEqualTo []}) exitWith {false};

// ---- Pool Lookup ----
private _categoryPool = vgm_s_voicelines_pools getOrDefault [_category, createHashMap];
private _lines = _categoryPool getOrDefault [_subcategory, []];

if (_lines isEqualTo []) exitWith {
    format ["VGM Voicelines: No lines found for %1.%2", _category, _subcategory] call vgm_g_fnc_logWarning;
    false
};

// ---- Cooldown Checks ----
private _now = serverTime;

// Global cooldown
private _globalCD = if (_priority) then {5} else {vgm_s_voicelines_globalCooldown};
if (_now - vgm_s_voicelines_lastPlayTime < _globalCD) exitWith {false};

// Category cooldown (skipped for priority lines)
private _catBlocked = false;
if (!_priority) then {
    private _catKey = format ["%1_%2", _category, _subcategory];
    private _lastCatPlay = vgm_s_voicelines_cooldowns getOrDefault [_catKey, -999];
    private _catCooldown = vgm_s_voicelines_categoryCooldowns getOrDefault [_category, 60];
    if (_now - _lastCatPlay < _catCooldown) then {_catBlocked = true};
};
if (_catBlocked) exitWith {false};

// ---- Pick Random Line ----
private _line = selectRandom _lines;

// ---- Determine Speaker ----
private _speaker = if (isNull _speakerUnit) then {
    vgm_s_voicelines_coveyUnit
} else {
    _speakerUnit
};

if (isNull _speaker) exitWith {
    "VGM Voicelines: No speaker unit available" call vgm_g_fnc_logWarning;
    false
};

// ---- Play via sideRadio ----
[_speaker, _line] remoteExec ["sideRadio", 0];

// ---- Update Cooldowns ----
vgm_s_voicelines_lastPlayTime = _now;
private _catKey = format ["%1_%2", _category, _subcategory];
vgm_s_voicelines_cooldowns set [_catKey, _now];

format ["VGM Voicelines: Played %1.%2 -> %3", _category, _subcategory, _line] call vgm_g_fnc_logInfo;

true
