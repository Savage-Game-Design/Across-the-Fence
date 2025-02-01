/*
    File: fn_ai_getEnemySquadTemplate.sqf
    Author: Savage Game Design
    Date: 2024-02-10
    Last Update: 2025-01-24
    Public: Yes

    Description:
        Creates the template for an enemy squad, to be used with vgm_s_fnc_virtsquad_create.

    Parameter(s):
        _unitClasses - Array of unit classes [Array, defaults to [] (empty array)]
        _position - Position to spawn units around [Position3D]
        _missionId - Mission the squad is being used in [STRING]

    Returns:
        Template for a virtual squad [HASHMAP]

    Example(s):
        [["vn_some_unit", "vn_some_other_unit"], [0, 0, 0], _mission get "public" get "id"] call vgm_s_fnc_director_getEnemySquadTemplate;
 */

params [["_unitClasses", []], "_position", "_missionId"];

createHashMapFromArray [
    ["pos", _position],
    ["composition", _unitClasses],
    ["groupVars", []],
    ["side", east],
    ["deleteOnDespawn", false],
    ["missionId", _missionId],
    ["btreeName", "enemyAI"]
]
