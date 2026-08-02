/*
    File: fn_skill_passives_targetFolder.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Progressive intel reveal on the mission map. Each level reveals more:
        Level 1: Reveals trail signs near enemy sites on the map.
        Level 2: Reveals approximate site activity areas on the map.
        Level 3: Reveals location hints for potential sites.

        The trait value indicates the highest level learned.

    Parameter(s):
        _level - Positive for apply (1/2/3), negative for unapply (-1/-2/-3) [NUMBER]

    Returns:
        Nothing

    Example(s):
        1 call vgm_c_fnc_skill_passives_targetFolder
        -2 call vgm_c_fnc_skill_passives_targetFolder
 */

params ["_level"];

if (_level > 0) then {
    // Apply: set trait to this level (or keep higher if already learned a higher one)
    private _current = player getUnitTrait "vgm_skill_targetFolder";
    if (!(_current isEqualType 0) || {_current < _level}) then {
        player setUnitTrait ["vgm_skill_targetFolder", _level, true];
    };
    private _stored = player getVariable ["vgm_g_skill_targetFolder", 0];
    player setVariable ["vgm_g_skill_targetFolder", _level max _stored, true];

    // Subscribe to mission end to clean up intel markers (only once)
    if (isNil "vgm_c_skill_targetFolder_endEh") then {
        vgm_c_skill_targetFolder_endEh = ["vgm_mission_ended", {
            {deleteMarkerLocal _x} forEach (missionNamespace getVariable ["vgm_c_skill_targetFolder_markers", []]);
            vgm_c_skill_targetFolder_markers = [];
        }] call para_g_fnc_event_subscribe;
    };
} else {
    // Unapply: reduce to the level below
    private _newLevel = (abs _level) - 1;
    player setUnitTrait ["vgm_skill_targetFolder", _newLevel max 0, true];
    player setVariable ["vgm_g_skill_targetFolder", _newLevel max 0, true];

    // If fully unapplied, clean up markers and unsubscribe
    if (_newLevel <= 0 && {!isNil "vgm_c_skill_targetFolder_endEh"}) then {
        {deleteMarkerLocal _x} forEach (missionNamespace getVariable ["vgm_c_skill_targetFolder_markers", []]);
        vgm_c_skill_targetFolder_markers = [];
        [vgm_c_skill_targetFolder_endEh] call para_g_fnc_event_unsubscribe;
        vgm_c_skill_targetFolder_endEh = nil;
    };
};
