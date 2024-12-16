/*
    File: fn_mission_objects_call.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2024-12-16
    Public: No

    Description:
        Execute given code on local instances of the objects.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_g_fnc_mission_objects_call
 */

params [
    "_missionId",
    "_objectIds",
    ["_fnc_callback", {}, [{}]]
];

if (remoteExecutedOwner != 2) then {
    format ["Mission object call should be called from server to prevent object desync, expected 2 got %1", remoteExecutedOwner] call vgm_g_fnc_logWarning;
};

format ["Call on %1 local mission objects for %2", count _objectIds, _missionId] call vgm_g_fnc_logInfo;

private _localObjectsData = vgm_g_mission_objects getOrDefault [_missionId, createHashMap, true];

{
    private _id  = _x;
    if !(_id in _localObjectsData) then {continue};
    private _object = _localObjectsData get _id;

    [_object] call _fnc_callback;

} forEach _objectIds;
