/*
    File: fn_terrainIndex_loadIndex.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-04-05
    Public: No

    Description:
        Loads a terrain index from vgm_map_indices config for the current map.

    Parameter(s):
        _name - Name of the terrain index [STRING]

    Returns:
        _index - Terrain index [HASHMAP]

    Example(s):
        _terrainIndex = ["land"] call vgm_s_fnc_terrainIndex_loadIndex;
 */

params ["_name"];

private _configIndex = getArray(missionConfigFile >> "vgm_terrain_indices" >> toLower worldName >> _name);
if (count _configIndex == 0) exitWith { [] }; // No index found

createHashMapFromArray _configIndex

