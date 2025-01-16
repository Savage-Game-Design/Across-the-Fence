/*
    File: fn_virtsquad_spawnLoop.sqf
    Author:
    Date: 2025-01-11
    Last Update: 2025-01-16
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

if (vgm_s_virtsquad_playerQueue isEqualTo []) then {
    vgm_s_virtsquad_playerQueue = allPlayers;
};

if (vgm_s_virtsquad_spawnedSquadQueue isEqualTo []) then {
    vgm_s_virtsquad_spawnedSquadQueue = flatten (values vgm_s_virtsquad_perMissionSquadsInfo apply {values (_x get "spawnedSquads")});
};

// Check for any unspawned squads in range of players, and set them to spawn in.
if (vgm_s_virtsquad_playerQueue isNotEqualTo []) then {
    private _player = vgm_s_virtsquad_playerQueue deleteAt (count vgm_s_virtsquad_playerQueue - 1);
    if (!isNull _player) then {
        // This will always default to the global index if the mission doesn't exist, or virtsquads doesn't know about the mission.
        private _vSquadIndex = [[getPlayerID _player] call vgm_s_fnc_missions_getAssignedMissionId] call vgm_s_fnc_virtsquad_getMissionSquadsInfo get "vSquadIndex";
        private _inRange = [_vSquadIndex, [getPosATL _player, vgm_s_virtsquad_spawnRange, vgm_s_virtsquad_spawnRange]] call vgm_g_fnc_posindex_inAreaArray;
        {
            // Using a hash and separate spawing loop avoids us scheduling many spawns of the same squad, if the scheduler is running slow.
            vgm_s_virtsquad_spawnQueue set [_x get "id", _x];
        } forEach _inRange;
    };
};

// Check for any spawned squads with no players nearby, and schedule them to despawn.
if (vgm_s_virtsquad_spawnedSquadQueue isNotEqualTo []) then {
    private _squad = vgm_s_virtsquad_spawnedSquadQueue deleteAt (count vgm_s_virtsquad_spawnedSquadQueue - 1);
    // Need to check if it can be deleted - Make sure it isn't already deleted, or already despawned
    // This can happen because the queue isn't cleaned when things are despawned.
    if (!("group" in _squad) || "deleting" in _squad || "deleted" in _squad) exitWith {};
    // We could check only players on the mission - but when running only one squad per frame, it isn't worth the extra script time to create that list.
    private _playersInRange = allPlayers inAreaArray [getPosATL leader (_squad get "group"), vgm_s_virtsquad_despawnRange, vgm_s_virtsquad_despawnRange];
    if (_playersInRange isEqualTo []) then {
        vgm_s_virtsquad_despawnQueue set [_squad get "id", _squad];
    };
};
