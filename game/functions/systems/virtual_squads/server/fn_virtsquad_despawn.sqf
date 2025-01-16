/*
    File: fn_virtual_despawn.sqf
    Author:
    Date: 2025-01-10
    Last Update: 2025-01-16
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

diag_log format ["Depspawning: %1", _squad];

private _group = _squad get "group";
private _deleteOnDespawn = _squad getOrDefault ["deleteOnDespawn", false] || { alive _x } count units _group <= 0;

if (isNil "_group") exitWith {
    [format ["Despawn called on squad that isn't spawned: %1", _squad get "id"]] call vgm_g_fnc_logWarning;
};

if (!_deleteOnDespawn) then {
    _squad set ["pos", getPosATL leader _group];
    _squad set ["vSquadIndexSlot", [vgm_s_virtsquad_vSquadIndex, _squad] call vgm_g_fnc_posindex_add];

    private _squadVars = _squad getOrDefault ["groupVars", [], true];

    // Only save variables that the virtual squad system knows about.
    // The goal is to minimise the chance of bugs due to something incorrectly being carried over.
    {
        _x params ["_varName"];
        // Update the value of the variable
        _x set [1, _group getVariable _varName];
    } forEach _squadVars;
};

if (_deleteOnDespawn) then {
    [_squad] call vgm_s_fnc_virtsquad_delete;
} else {
    [_group] call vgm_s_fnc_virtsquad_destroyGroup;
};

_squad deleteAt "group";
