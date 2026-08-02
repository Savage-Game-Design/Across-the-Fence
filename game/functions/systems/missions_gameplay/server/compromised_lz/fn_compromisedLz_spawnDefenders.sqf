/*
    File: fn_compromisedLz_spawnDefenders.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        onSpawn callback for compromised LZ virtual squads. Configures
        the spawned group for ambush: units go prone, captive, hidden
        under spawned bush objects. Starts the ambush trigger monitor.

    Parameter(s):
        _squad - Virtual squad hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        Called automatically by virtual squad system via onSpawn.
*/

params ["_squad"];

private _group = _squad get "group";
private _lzPosition = _squad get "lzPosition";
private _missionId = _squad get "missionId";
private _units = units _group;

// Build defender data
private _defenderData = createHashMap;
_defenderData set ["group", _group];
_defenderData set ["units", _units];
_defenderData set ["lzPosition", _lzPosition];
_defenderData set ["missionId", _missionId];
_defenderData set ["ambushTriggered", false];
_defenderData set ["firedNear", false];
_defenderData set ["squad", _squad];

// Bush classnames for visual concealment
private _bushClasses = [
    "Land_vn_b_arundod3s_f",
    "Land_vn_b_arundod2s_f"
];

// Units go prone, face outward, and hide from AI (prevents heli gunners spoiling the ambush)
private _bushes = [];
{
    _x setCaptive true;
    _x setUnitPos "DOWN";
    _x doWatch (_lzPosition getPos [200, _x getDir _lzPosition]);
    _x disableAI "MOVE";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x setUnitTrait ["camouflageCoef", 0];
    _x addEventHandler ["FiredNear", {
        params ["_unit"];
        private _defenderData = _unit getVariable ["vgm_compromisedLz_defenderData", createHashMap];
        if (_defenderData getOrDefault ["ambushTriggered", false]) exitWith {};
        _defenderData set ["firedNear", true];
    }];

    // Spawn a bush on top to visually conceal
    private _bush = createSimpleObject [selectRandom _bushClasses, getPosATL _x, true];
    _bush setDir random 360;
    _bushes pushBack _bush;
} forEach _units;

_defenderData set ["bushes", _bushes];

// Configure group behavior
_group setBehaviourStrong "AWARE";
_group setCombatMode "YELLOW";
_group setSpeedMode "LIMITED";

// Store reference so FiredNear EH can access it
{_x setVariable ["vgm_compromisedLz_defenderData", _defenderData]} forEach _units;

// Store in tracking hashmap
private _key = format ["%1_%2", _missionId, hashValue _lzPosition];
vgm_s_compromisedLz_occupiedLzs set [_key, _defenderData];

// Start ambush trigger monitor
[_lzPosition, _defenderData, _missionId] spawn vgm_s_fnc_compromisedLz_triggerAmbush;

format ["Compromised LZ: onSpawn — configured %1 defenders at %2 for mission %3",
    count _units, _lzPosition, _missionId] call vgm_g_fnc_logInfo;
