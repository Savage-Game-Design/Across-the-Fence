/*
    File: fn_virtsquad_spawn.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-01-11
    Public: No

    Description:
        Spawns a virtual squad's group and units.

    Parameter(s):
        _squad - Squad to spawn [HASHMAP]

    Returns:
       Group created [ARRAY]

    Example(s):
        [_squad] call vgm_s_fnc_virtsquad_spawn;
 */

params ["_squad"];

if ("group" in _squad) exitWith {
    ["Attempt to spawn a squad that's already spawned in. Squad ID: %1", _squad get "id"] call vgm_g_fnc_logWarning;
};

private _group = [_squad get "composition", _squad get "side", _squad get "pos", _squad get "missionId"] call vgm_s_fnc_ai_createEnemySquad;

_squad set ["group", _group];
// Shouldn't be a circular reference memory leak, as the group being deleted should clear this reference
_group setVariable ["vgm_s_virtsquad_squad", _squad];
// Add to the spawned groups list, so it's passed to "should despawn" checks.
vgm_s_virtsquad_spawnedSquads set [_squad get "id", _squad];
// Squad can be removed from the virtual squad index, as it's now spawned - we don't want to be running "should spawn" checks on it.
[vgm_s_virtsquad_vSquadIndex, _squad get "vSquadIndexSlot"] call vgm_g_fnc_posindex_deleteAt;

{
    _group setVariable (_x select [0, 3]);
} forEach (_squad get "groupVars");

// Start running the behaviour tree, now the group is on the client.
// Persists tree execution even if locality changes.
if ("btreeName" in _squad) then {
    [_group, _squad get "btreeName"] call vgm_s_fnc_btree_setTreeByNameGlobal;
};
_group
