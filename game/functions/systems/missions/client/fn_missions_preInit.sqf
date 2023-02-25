/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-20
    Public: Yes

    Description:
        Prepares the mission system on the client for initialisation

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_missions_preInit
 */

private _emptyMissionsHashmap = createHashMap;

localNamespace setVariable ["vgm_c_missions_data", createHashMapFromArray [
    ["missions", _emptyMissionsHashmap],
    ["currentMission", nil]
]];
