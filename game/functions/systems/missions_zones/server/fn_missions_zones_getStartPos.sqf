/*
    File: fn_missions_zones_getStartPos.sqf
    Author: Savage Game Design
    Date: 2024-04-04
    Last Update: 2024-08-21
    Public: Yes

    Description:
        Get starting position for mission zone.

    Parameter(s):
        _zone - Name of the zone marker

    Returns:
        Position ASL [ARRAY]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_zone"];

private _startPos = selectRandom ([_zone] call vgm_s_fnc_loc_getTargetBoxLocations get "lz");
_startPos set [2, 0];

AGLToASL _startPos
