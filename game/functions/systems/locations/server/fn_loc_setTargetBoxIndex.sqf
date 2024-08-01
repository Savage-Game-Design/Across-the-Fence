/*
    File: fn_loc_setTargetBoxIndex.sqf
    Author: Savage Game Design
    Date: 2024-07-22
    Last Update: 2024-07-27
    Public: Yes

    Description:
        Sets the target box location index for the given target box name.

        Format is a HashMap mapping: Target box ID -> Site Type ID -> Array of positions

    Parameter(s):
        _targetBoxId - Name / ID of the target box [String]
        _index - Index to add [HashMap]

    Returns:
        N/A

    Example(s):
        ["1", createHashMapFromArray [
            ["my_site_type", [[0, 0, 0], [1, 1, 0]]]
        ]] call vgm_s_fnc_loc_setTargetBoxIndex;
 */

params ["_targetBoxId", "_index"];

private _targetBoxIndexes = localNamespace getVariable ["vgm_s_loc_targetBoxIndexes" , createHashMap];

_targetBoxIndexes set [_targetBoxId, _index];

localNamespace setVariable ["vgm_s_loc_targetBoxIndexes", _targetBoxIndexes];
