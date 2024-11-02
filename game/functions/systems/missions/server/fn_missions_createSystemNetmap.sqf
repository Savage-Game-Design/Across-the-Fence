/*
    File: fn_missions_createSystemNetmap.sqf
    Author: Savage Game Design
    Date: 2024-08-13
    Last Update: 2024-10-29
    Public: Yes

    Description:
        Create system netmap in specified mission id.

    Parameter(s):
        _missionId - Id of the mission to get the netmap from [NUMBER]
        _systemName - Name of the system [STRING]

    Returns:
        Netmap [HASHMAP]

    Example(s):
        private _netmap = [_missionId, "systemName"] call vgm_s_fnc_missions_createSystemNetmap;
        [_netmap, "myArray", []] call para_s_fnc_netmap_set;
 */

params [
    ["_missionId", -1, [0]],
    ["_systemName", "", [""]]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Unable to add system ""%2"" netmap to a mission: %1", _missionId, _systemName] call vgm_g_fnc_logError;
};

private _systemKey = format ["system_%1", _systemName];
private _missionPublic = _mission get "public";
if (_systemKey in _missionPublic) exitWith {
    format ["System ""%2"" is already registered in mission: %1", _missionId, _systemName];
};

private _systemNetmap = [] call para_s_fnc_netmap_createNetmap;
[_systemNetmap, _missionPublic] call para_s_fnc_netmap_setOwningNetmap;

[_missionPublic, _systemKey, _systemNetmap] call para_s_fnc_netmap_set;

_systemNetmap // return
