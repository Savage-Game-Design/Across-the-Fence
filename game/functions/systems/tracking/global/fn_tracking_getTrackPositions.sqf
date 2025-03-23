/*
    File: fn_tracking_getTrackPositions.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2024-11-02
    Public: Yes

    Description:
        Returns the list of tracking positions - SHOULD NOT BE MODIFIED otherwise it'll break the tracking system.

    Parameter(s):
        _trackingGroupId - Tracking group whose tracks should be searched [STRING]

    Returns:
        Positions [ARRAY]

    Example(s):
        [1] call vgm_g_fnc_tracking_getTrackPositions;
 */

params ["_trackingGroupId"];

if !(_trackingGroupId in vgm_l_tracking_trackingGroups) exitWith { [] };

private _trackingGroup = vgm_l_tracking_trackingGroups get _trackingGroupId;

_trackingGroup get "trackPositions"
