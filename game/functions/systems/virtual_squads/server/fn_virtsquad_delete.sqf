/*
    File: fn_virtsquad_delete.sqf
    Author: Savage Game Design
    Date: 2025-01-10
    Last Update: 2025-01-11
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

private _group = _squad get "group";

if (!isNil "_group") then {
    [_group] call vgm_s_fnc_virtsquad_destroyGroup;
};

vgm_s_virtsquad_squads deleteAt (_squad get "id");
[vgm_s_virtsquad_vSquadIndex, _squad get "vSquadIndexSlot"] call vgm_g_fnc_posindex_deleteAt;

_squad set ["deleted", true];
