/*
    File: fn_tracking_debugShowTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-18
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Shows debugging markers on tracks for the local player.

    Parameter(s):
        _trackingGroupId - Group to reveal tracks for [STRING]

    Returns:
        Nothing

    Example(s):
        ["1"] call vgm_g_fnc_tracking_showTracksDebug;
 */

params ["_trackingGroupId"];

if (isNil "vgm_l_tracking_debugInfo") then {
    vgm_l_tracking_debugInfo = createHashMap;
};

private _debugInfo = createHashMapFromArray [
    ["objects", []]
];
vgm_l_tracking_debugInfo set [_trackingGroupId, _debugInfo];

_debugInfo set ["scriptHandle", [_trackingGroupId] spawn {
    params ["_trackingGroupId"];

    while { _trackingGroupId in vgm_l_tracking_debugInfo } do {
        // Clean up if the tracking group no longer exists.
        if !(_trackingGroupId in vgm_l_tracking_trackingGroups) exitWith {
            [_trackingGroupId] call vgm_g_fnc_tracking_debugHideTracks;
        };

        private _trackingGroup = vgm_l_tracking_trackingGroups get _trackingGroupId;
        private _debugInfo = vgm_l_tracking_debugInfo get _trackingGroupId;
        private _latestTime = _debugInfo getOrDefault ["latestTime", 0];
        private _newLatestTime = _latestTime;

        {
            if (_x get "time" < _latestTime) exitWith {};

            _debugInfo get "objects" pushBack (
                createVehicleLocal ["Sign_Arrow_Large_Pink_F", _x get "pos", [], 0, "CAN_COLLIDE"]
            );
        } forEachReversed (_trackingGroup get "trackDetails");
        sleep 1;
    };
}];
