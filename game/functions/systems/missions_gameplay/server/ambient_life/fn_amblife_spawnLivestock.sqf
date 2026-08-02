/*
    File: fn_amblife_spawnLivestock.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns livestock clusters (chickens, goats) near buildings using createAgent.
        Animals are tracked for cleanup on mission end.

    Parameter(s):
        _missionId         - Mission ID [NUMBER]
        _buildingPositions - Array of building positions [ARRAY]
        _count             - Number of livestock clusters to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _buildings, 3] call vgm_s_fnc_amblife_spawnLivestock;
 */

params ["_missionId", "_buildingPositions", "_count"];

if (_count <= 0 || count _buildingPositions == 0) exitWith {};

private _animals = vgm_s_amblife_missionAnimals get _missionId;

for "_i" from 1 to _count do {
    private _origin = selectRandom _buildingPositions;
    private _clusterSize = 2 + floor random 3; // 2-4 animals

    for "_j" from 1 to _clusterSize do {
        private _spawnPos = _origin getPos [3 + random 8, random 360];
        private _class = selectRandom vgm_s_amblife_animalClasses;
        private _agent = createAgent [_class, _spawnPos, [], 2, "NONE"];
        _animals pushBack _agent;
    };
};
