/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-20
    Public: No

    Description:
        Initialises the mission system, setting up necessary state.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_missions_initSystem
 */


private _missionsData = createHashMapFromArray [
    ["missions", createHashMap],
    ["currentMissionAssignments", createHashMap]
];

localNamespace setVariable ["vgm_missions_data", _missionsData];

// TODO - Disconnect handling
// - Remove player from mission
