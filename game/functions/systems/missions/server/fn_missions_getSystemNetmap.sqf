/*
    File: fn_missions_getSystemNetmap.sqf
    Author: Savage Game Design
    Date: 2024-08-13
    Last Update: 2024-08-24
    Public: Yes

    Description:
        Fetch system netmap from specified mission id.

    Parameter(s):
        _missionId - Id of the mission to get the netmap from [NUMBER]
        _systemName - Name of the system [STRING]

    Returns:
        Netmap [HASHMAP]

    Example(s):
        [_missionId, "systemName"] call vgm_s_fnc_missions_getSystemNetmap;
 */

params [
    ["_missionId", -1, [0]],
    ["_systemName", "", [""]]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Unable to get system ""%2"" netmap for id: %1", _missionId, _systemName] call vgm_g_fnc_logError;
    createHashMap // return
};

private _systemKey = format ["system_%1", _systemName];
private _missionPublic = _mission get "public";

_missionPublic getOrDefault [_systemKey, createHashMap] // return
