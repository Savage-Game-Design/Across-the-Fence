/*
    File: sites_spawn.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-09-20
    Public: Yes

    Description:
        Spawns in a new site of the given type at the given location.

    Parameter(s):
        _typeId - Name of a previously registered site type [STRING]
        _pos2D - Position to spawn the site at. Only the 2D coordinates (x, y) matter [ARRAY]

    Returns:
        Site info - This should be treated as a black box by other systems

    Example(s):
        ["vgm_bunker", [100, 100]] call vgm_s_fnc_sites_spawn;
 */

params ["_typeId", "_pos2D"];

_pos2D = _pos2D select [0, 2];

private _siteType = localNamespace getVariable "vgm_s_sites_siteTypes" get _typeId;

if (isNil "_siteType") exitWith {
    [format ["Failed to spawn unknown site '%1'", _typeId]] call vgm_g_fnc_logError;
};

private _spawnResult = [_pos2D] call (_siteType get "spawnFunction");

private _site = createHashMapFromArray [
    ["id", hashValue _pos2D],
    ["type", _siteType],
    ["pos", _pos2D],
    ["objects", _spawnResult select 0],
    ["ownedSites", []]
];

["vgm_sites_siteSpawned", [_site]] call para_g_fnc_event_triggerServer;

_site // return
