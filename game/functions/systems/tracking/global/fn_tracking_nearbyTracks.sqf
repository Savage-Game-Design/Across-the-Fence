/*
    File: fn_tracking_nearbyTracks.sqf
    Author:
    Date: 2024-03-08
    Last Update: 2024-03-09
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

params ["_trackingGroupId", "_position", "_distance"];

if !(_trackingGroupId in vgm_l_tracking_trackingGroups) exitWith { [] };

private _trackingGroup = vgm_l_tracking_trackingGroups get _trackingGroupId;

// TODO - Prune tracks, or LOD them. This number could grow and become a performance issue.
private _nearbyIndexes = (_trackingGroup get "trackPositions")
    inAreaArrayIndexes [_position, _distance, _distance, 0, false];

private _trackDetails = _trackingGroup get "trackDetails";

_nearbyIndexes apply { _trackDetails # _x }
