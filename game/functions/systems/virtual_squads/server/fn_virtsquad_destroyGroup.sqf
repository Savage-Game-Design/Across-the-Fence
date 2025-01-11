/*
    File: fn_virtsquad_destroyGroup.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-01-11
    Public: No

    Description:
        Deletes a group, and removes all references to it.

        Internal use only.

    Parameter(s):
        _group - Group to destroy [GROUP]

    Returns:
        Nothing

    Example(s):
        [_squad get "group"] call vgm_s_fnc_virtsquad_destroyGroup;
 */

params ["_group"];

{
    deleteVehicle _x;
} forEach units _group;

deleteGroup _group;

vgm_s_virtsquad_spawnedSquads deleteAt (_squad get "id");
