/*
    File: fn_ai_getZombieSquadTemplate.sqf
    Author: Savage Game Design
    Date: 2024-02-10
    Last Update: 2025-10-23
    Public: Yes

    Description:
        Creates the template for an enemy zombie squad, to be used with vgm_s_fnc_virtsquad_create.

    Parameter(s):
        _composition - Array of unit classes [Array, defaults to [] (empty array)]
        _position - Position to spawn units around [Position3D]
        _missionId - Mission the squad is being used in [STRING]

    Returns:
        Template for a virtual squad [HASHMAP]

    Example(s):
        [["vn_some_unit", "vn_some_other_unit"], [0, 0, 0], _mission get "public" get "id"] call vgm_s_fnc_director_getZombieSquadTemplate;
 */

params [["_composition", []], "_position", "_missionId"];

createHashMapFromArray [
    ["pos", _position],
    ["composition", _composition],
    ["groupVars", createHashMap],
    ["side", independent],
    ["deleteOnDespawn", false],
    ["missionId", _missionId],
    // Zombies behave weirdly when in groups
    ["sizeRange", [1, 1]],
    ["onSpawn", {
        params ["_squad"];
        private _group = _squad get "group";
        {
            _x setVariable ["vgm_l_zombie_goToPos", _group getVariable "vgm_l_zombie_goToPosInitial", true];
            [_x] remoteExecCall ["vgm_g_fnc_zombie_init", _x];
        } forEach units _group;
    }]
]
