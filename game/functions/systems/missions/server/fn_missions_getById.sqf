/*
    File: fn_missions_getById.sqf
    Author: Savage Game Design
    Date: 2023-12-19
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Get mission by its ID.

    Parameter(s):
        _missionId - Mission ID [NUMBER]

    Returns:
        Mission or nil [HASHMAP]

    Example(s):
        [2] call vgm_s_fnc_missions_getById
 */

params [["_missionId", -1, [0]]];

localNamespace getVariable "vgm_missions" get _missionId // return
