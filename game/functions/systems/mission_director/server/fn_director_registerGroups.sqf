/*
    File: fn_director_createSquad.sqf
    Author: Savage Game Design
    Date: 2024-03-01
    Last Update: 2024-03-01
    Public: No

    Description:
        Register AI group to mission director. Broadcast creation event to participating players.

    Parameter(s):
        _mission - Mission [HASHMAP]
        _groups - Groups to register [ARRAY]

    Returns:
        Nothing

    Example(s):
        [_mission, [_grp]] call vgm_s_fnc_director_registerGroups
 */

params [
    "_mission",
    ["_groups", [], [[]]]
];

_mission get "director" get "aiGroups" append _groups;

["vgm_mission_director_squadCreated", _groups, values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;
