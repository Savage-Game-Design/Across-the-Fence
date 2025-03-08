/*
    File: fn_virtual_despawn.sqf
    Author:
    Date: 2025-01-10
    Last Update: 2025-03-01
    Public: No

    Description:
        Despawns a virtual squad.

    Parameter(s):
        _squad - Squad to despawn [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_group getVariable "vgm_s_virtsquad_squad"] call vgm_s_fnc_virtsquad_despawn;
 */

params ["_squad"];

// Safeguard against despawning a squad that's deleted or mid-deletion.
if ("deleting" in _squad || "deleted" in _squad) exitWith {
    [format ["Despawn called on deleted squad: %1", _squad get "id"]] call vgm_g_fnc_logWarning;
};

private _group = _squad get "group";

if (isNil "_group") exitWith {
    [format ["Despawn called on squad that isn't spawned: %1", _squad get "id"]] call vgm_g_fnc_logWarning;
};

private _deleteOnDespawn = _squad getOrDefault ["deleteOnDespawn", false] || units _group findIf { alive _x } == -1;


if (!_deleteOnDespawn) then {
    _squad set ["pos", getPosATL leader _group];
    private _missionInfo = [_squad get "missionId"] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;
    _squad set ["vSquadIndexSlot", [_missionInfo get "vSquadIndex", _squad] call vgm_g_fnc_posindex_add];

    private _squadVars = _squad getOrDefault ["groupVars", createHashMap, true];

    // Only save variables that the virtual squad system knows about.
    // The goal is to minimise the chance of bugs due to something incorrectly being carried over.
    {
        // Update the value of the variable
        _squadVars get _x set [0, _group getVariable _x];
    } forEach keys _squadVars;
};

if (_deleteOnDespawn) then {
    [_squad] call vgm_s_fnc_virtsquad_delete;
} else {
    [_group] call vgm_s_fnc_virtsquad_destroyGroup;
};

_squad deleteAt "group";
