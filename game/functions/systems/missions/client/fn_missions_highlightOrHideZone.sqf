/*
    File: fn_missions_highlightOrHideZone.sqf
    Author: Savage Game Design
    Date: 2025-09-07
    Last Update: 2025-09-07
    Public: No

    Description:
        If mission is assigned to the player: highlight the zone to allow players to plan.
        Else, removes any existing target box and resets map.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_missions_highlightOrHideZone", _player];
*/

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

// will hide zone target boxes if no mission assigned
[] call vgm_c_fnc_missions_coverMap;

if (isNil "_currentMission") exitWith {};

// zoom map on the mission area if a mission is assigned
vgm_missions_zoomOnMapScript = (_currentMission get "targetZone") spawn {
    [_this] call vgm_g_fnc_loc_getTargetBoxBounds params ["_pos", "_size"];
    waitUntil {visibleMap}; // can't animate hidden map
    [
        _size vectorMultiply 2.5,
        _pos,
        1
    ] call BIS_fnc_zoomOnArea;
};
