/*
    File: fn_mission_gameplay_scouting_onPhoto.sqf
    Author: Savage Game Design
    Date: 2024-09-30
    Last Update: 2024-10-30
    Public: No

    Description:
        Handle player snapping a photo of site object.

    Parameter(s):
        _cursorTarget - Object that was photographed [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorTarget] call vgm_c_fnc_missions_gameplay_scouting_onPhoto
 */

#define GET_DISPLAY_MAP (findDisplay 12)

params ["_cursorTarget"];

if !(_cursorTarget getVariable ["vgm_missions_gameplay_scouting_spottable", false]) exitWith {};

GET_DISPLAY_MAP setVariable ["vgm_site_photoObject", _cursorTarget];
["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;

// TODO check if this can be event based
[_cursorTarget] spawn {
    sleep 0.3;
    openMap [true, false];
    waitUntil {!visibleMap};

    if (!isNil {GET_DISPLAY_MAP getVariable "vgm_site_photoObject"}) then {
        playSoundUI ["hint"];
    };
    GET_DISPLAY_MAP setVariable ["vgm_site_photoObject", nil];
    ["refreshUI", GET_DISPLAY_MAP] call vgm_c_fnc_displayNotepad;
};
