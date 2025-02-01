/*
    File: fn_virtsquad_delete.sqf
    Author: Savage Game Design
    Date: 2025-01-10
    Last Update: 2025-01-16
    Public: Yes

    Description:
        Deletes a virtual squad.

    Parameter(s):
        _squad - Squad to delete [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_squad] call vgm_s_fnc_virtsquad_delete;
 */

params ["_squad"];

// Flag this early, as this call might span multiple frames.
_squad set ["deleting", true];

private _group = _squad get "group";
private _missionInfo = [_squad get "missionId"] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;

if (!isNil "_group") then {
    [_group] call vgm_s_fnc_virtsquad_destroyGroup;
};

// Check in case the squad is spawned in and not in this index, or other code is executing
// and we're in the brief period of time where we're in the index AND spawned in.
if ("vSquadIndexSlot" in _squad) then {
    [_missionInfo get "vSquadIndex", _squad get "vSquadIndexSlot"] call vgm_g_fnc_posindex_deleteAt;
};

_missionInfo get "squads" deleteAt (_squad get "id");

_squad set ["deleted", true];

["vgm_virtsquad_deleted", [_squad]] call para_g_fnc_event_triggerLocal;
