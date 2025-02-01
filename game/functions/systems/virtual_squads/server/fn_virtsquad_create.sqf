#include "script_component.inc"
/*
    File: fn_virtsquad_create.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-01-16
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
            ["missionId", _missionPublic get "id"],
            // Optional - behaviour tree to enable on the squad when they're spawned
            ["btreeName", "enemyAI"]
        ] call vgm_s_fnc_squad_create;
 */

params ["_groupDefinition"];

// Copy, so many groups can be made from one template.
private _squad = +_groupDefinition;

private _squadId = vgm_s_virtsquad_nextId;
vgm_s_virtsquad_nextId = vgm_s_virtsquad_nextId + 1;
_squad set ["id", _squadId];

_squad getOrDefault ["side", east, true];
// Assign the squad to the global mission, if there's no mission specified
_squad getOrDefault ["missionId", GLOBAL_MISSION_ID, true];

// Create the container for the mission info, if this is the first squad on the mission.
private _missionInfo = vgm_s_virtsquad_perMissionSquadsInfo getOrDefaultCall [_squad get "missionId", vgm_s_fnc_virtsquad_createMissionSquadsInfo, true];
// Add to the list of all squads on the mission
_missionInfo get "squads" set [_squadId, _squad];
// Add to the list of unspawned squads
private _slot = [_missionInfo get "vSquadIndex", _squad] call vgm_g_fnc_posindex_add;
_squad set ["vSquadIndexSlot", _slot];

// Group is only set when the squad spawns
//_squad set ["group", nil];

["vgm_virtsquad_created", [_squad]] call para_g_fnc_event_triggerLocal;

_squad
