/*
    File: fn_loc_getTargetBoxMarker.sqf
    Author: Savage Game Design
    Date: 2024-08-24
    Last Update: 2024-11-15
    Public: Yes

    Description:
        Gets the marker for a given target box

    Parameter(s):
        _targetBox - Name of the target box [STRING]

    Returns:
        Marker name [STRING]

    Example(s):
        ["oscar8"] call vgm_g_fnc_loc_getTargetBoxMarker;
 */

params ["_targetBox"];

format ["tbox_%1", _targetBox]
