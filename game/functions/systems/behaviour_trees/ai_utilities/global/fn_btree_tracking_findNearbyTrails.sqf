/*
    File: fn_btree_tracking_findNearbyTrails.sqf
    Author:
    Date: 2024-03-09
    Last Update: 2024-12-06
    Public: No

    Description:
        Finds nearby tracks to the AI group.

        Extracted as a utility function, to ensure it behaves the same across different nodes in the tree.

        Depends on the tracking system.

    Parameter(s):
        _group - Group to search for tracks near [GROUP]

    Returns:
        [_track, _nearestTrailPosition] [HASHMAP, PosATL] [ARRAY]

    Example(s):
        [_group] call vgm_g_fnc_btree_tracking_findNearbyTrails
 */

params ["_group"];

[
    _group getVariable "vgm_g_missionId",
    // This HAS to be ASL or it will give weird results.
    getPosATL leader _group,
    // How far to search for track nodes.
    // Performance / accuracy tradeoff. This should fairly reliably capture at least one node (which is all we need) when the player is sprinting.
    vgm_g_tracking_maxDistanceForSameTrail / 1.5,
    // Maximum distance from the trail. 20m is a bit big, but should help with finding it.
    // 5 works, but there's a higher risk of AI running across it and not detecting the trail due to the AI only running every few seconds.
    20
] call vgm_g_fnc_tracking_nearbyTrails;


