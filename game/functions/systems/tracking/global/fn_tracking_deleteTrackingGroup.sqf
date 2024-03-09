/*
    File: fn_tracking_deleteTrackingGroup.sqf
    Author:
    Date: 2024-03-09
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

params ["_trackingGroupId"];

vgm_l_tracking_trackingGroups deleteAt _trackingGroupId;
