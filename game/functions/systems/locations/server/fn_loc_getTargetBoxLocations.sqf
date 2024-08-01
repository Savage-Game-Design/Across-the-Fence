/*
    File: fn_loc_getTargetBoxLocations.sqf
    Author: Savage Game Design
    Date: 2024-06-01
    Last Update: 2024-07-22
    Public: No

    Description:
        Retrieves the locations for the given target box name.

    Parameter(s):
        _targetBoxName - Name of the target box [STRING]

    Returns:
        Index of locations in the target box [HashMap]

    Example(s):
        ["oscar8"] call vgm_s_fnc_loc_getTargetBoxLocations;
 */

params ["_targetBoxName"];

localNamespace getVariable "vgm_s_loc_targetBoxIndexes" getOrDefault [_targetBoxName, createHashMap]
