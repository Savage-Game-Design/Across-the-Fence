/*
    File: fn_virtsquad_spawn.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-04-04
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

// Safeguard against spawning in a deleted squad.
if ("deleting" in _squad || "deleted" in _squad) exitWith {};

private _missionId = _squad get "missionId";
private _mission = [_missionId] call vgm_g_fnc_missions_getPublicInfoById;
// Default to upper bound if we have no mission (which should never happen).
private _squadScaling = 1;
if (!isNil "_mission") then {
    private _playerCount = [_mission get "players"] call para_g_fnc_netmap_count;
    private _maxPlayers = _mission get "maxPlayers";
    _squadScaling = _playerCount / _maxPlayers;
} else {
    [format ["Attempted to spawn a virtual squad without valid mission - mission id (%1)", _missionId]] call vgm_g_fnc_logWarning;
};

private _composition = _squad get "composition";
private _sizeRange = _squad getOrDefault ["sizeRange", [ count _composition, count _composition ]];
private _size = round linearConversion [0, 1, _squadScaling, _sizeRange # 0, _sizeRange # 1, true];
private _unitClasses = [_composition, _size] call vgm_s_fnc_virtsquad_scaleComposition;

private _group = ([_unitClasses, _squad get "side", _squad get "pos"] call para_g_fnc_create_squad) # 1;

_squad set ["group", _group];
// Shouldn't be a circular reference memory leak, as the group being deleted should clear this reference
_group setVariable ["vgm_s_virtsquad_squad", _squad];
private _missionInfo = [_missionId] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;
// Add to the spawned groups list, so it's passed to "should despawn" checks.
_missionInfo get "spawnedSquads" set [_squad get "id", _squad];
// Squad can be removed from the virtual squad index, as it's now spawned - we don't want to be running "should spawn" checks on it.
[_missionInfo get "vSquadIndex", _squad get "vSquadIndexSlot"] call vgm_g_fnc_posindex_deleteAt;
_squad deleteAt "vSquadIndexSlot";

{
    _group setVariable ([_x] + _y);
} forEach (_squad get "groupVars");

_group setVariable ["vgm_g_missionId", _squad get "missionId", true];

//Set the squad's locality to the client with highest FPS
private _selectedClient = call para_s_fnc_loadbal_suggest_host;
_group setGroupOwner _selectedClient;

// Start running the behaviour tree, now the group is on the client.
// Persists tree execution even if locality changes.
if ("btreeName" in _squad) then {
    [_group, _squad get "btreeName"] call vgm_s_fnc_btree_setTreeByNameGlobal;
};

["vgm_virtsquad_spawned", [_squad]] call para_g_fnc_event_triggerLocal;

_group
