/*
    File: fn_sites_hints_getHintsInRange.sqf
    Author: Savage Game Design
    Date: 2025-08-18
    Last Update: 2025-08-18
    Public: No

    Description:
        Lists all site hints in range of the given point.

    Parameter(s):
        _center - PosATL of the search center [PosATL]
        _radius - Radius to search [NUMBER]

    Returns:
        Array of all site hint objects in range [ARRAY]

    Example(s):
        [getPosATL player, 30] call vgm_c_fnc_sites_hints_getHintsInRange;
 */

params ["_center", "_radius"];

vgm_sites_hints_objectsList inAreaArray [_center, _radius, _radius, 0, false, _radius];
