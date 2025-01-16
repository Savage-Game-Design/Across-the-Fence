/*
    File: fn_virtsquad_destroyGroup.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-01-16
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

if (isNull _group) exitWith {};

private _squad = _group getVariable "vgm_s_virtsquad_squad";

// Send squad in an array to facilitate easy batching as a future optimisation
["vgm_virtsquad_despawned", [_squad]] call para_g_fnc_event_triggerLocal;

{
    deleteVehicle _x;
} forEach units _group;

deleteGroup _group;

private _missionInfo = [_squad get "missionId"] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;
_missionInfo get "spawnedSquads" deleteAt (_squad get "id");
