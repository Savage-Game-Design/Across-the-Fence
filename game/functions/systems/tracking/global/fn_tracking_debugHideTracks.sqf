/*
    File: fn_tracking_debugHideTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-18
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Hides debugging markers on tracks for the local player.

    Parameter(s):
        _trackingGroupId - Group to reveal tracks for [STRING]

    Returns:
        Nothing

    Example(s):
        ["1"] call vgm_g_fnc_tracking_debugHideTracks;
 */

params ["_trackingGroupId"];

if (isNil "vgm_l_tracking_debugInfo") exitWith {};

private _debugInfo = vgm_l_tracking_debugInfo get _trackingGroupId;

if (isNil "_debugInfo") exitWith {};

{
    deleteVehicle _x;
} forEach (_debugInfo get "objects");

vgm_l_tracking_debugInfo deleteAt _trackingGroupId;
