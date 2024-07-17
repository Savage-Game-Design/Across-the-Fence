/*
    File: fn_btree_tracking_findNearbyTracks.sqf
    Author:
    Date: 2024-03-09
    Last Update: 2024-03-10
    Public: No

    Description:
        Finds nearby tracks to the AI group.

        Extracted as a utility function, to ensure it behaves the same across different nodes in the tree.

        Depends on the tracking system.

    Parameter(s):
        _group - Group to search for tracks near [GROUP]

    Returns:
        Most recent track or nil [HASHMAP]

    Example(s):
        [_group] call vgm_g_fnc_btree_tracking_findNearbyTracks
 */

params ["_group"];

[
    _group getVariable "vgm_g_missionId",
    getPosATL leader _group,
    75
] call vgm_g_fnc_tracking_nearbyTracks

