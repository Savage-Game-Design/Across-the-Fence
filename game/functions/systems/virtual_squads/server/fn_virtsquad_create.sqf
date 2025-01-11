/*
    File: fn_virtsquad_create.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-11
    Public: No

    Description:
        Creates a new virtual group, with the specified units and location.

        All variables to be set on groups/units are in this format:
            [name, value, isGlobal]

    Parameter(s):
        _groupDefinition - Definition for the group, see Example [HASHMAP]

    Returns:
        The virtual group created [HASHMAP]

    Example(s):
        createHashMapFromArray [
            ["pos", [0, 0, 0]],
            ["composition", [
                "vn_b_rifleman"
            ]],
            // Format: [name, value, isGlobal]
            ["groupVars", [
                ["vgm_g_order", "patrol", true]
            ]],
            // Optional - defaults to east
            ["side", east],
            ["deleteOnDespawn", false],
            // Optional - only needed if the squad is spawned for a mission.
            ["missionId", _missionPublic get "id"]
        ] call vgm_s_fnc_squad_create;
 */

params ["_groupDefinition"];

// Copy, so many groups can be made from one template.
private _squad = +_groupDefinition;

_squad set ["id", vgm_s_virtsquad_nextId];
vgm_s_squad_nextId = vgm_s_virtsquad_nextId + 1;

_squad getOrDefault ["side", east, true];

vgm_s_virtsquad_squads set [_squad get "id", _squad];
private _slot = [vgm_s_virtsquad_vSquadIndex, _squad] call vgm_g_fnc_posindex_add;
_squad set ["vSquadIndexSlot", _slot];

// Group is only set when the squad spawns
//_squad set ["group", nil];

_squad
