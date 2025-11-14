/*
    File: fn_groups_postInit.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-14
    Public: No

    Description:
        Sets up group events for the client.

        Set up as postInit so that other systems can register "vgm_groups_joined" in preInit and have it called for the first group the player joins.

 */

vgm_c_groups_lastGroup = grpNull;
vgm_c_groups_eachFrameEH = addMissionEventHandler ["EachFrame", {
    if (group player isEqualTo vgm_c_groups_lastGroup) exitWith {};
    private _lastGroup = vgm_c_groups_lastGroup;
    private _currentGroup = group player;
    vgm_c_groups_lastGroup = _currentGroup;

    private _existingJoinedEH = _lastGroup getVariable ["vgm_c_groups_joinedEH", -1];

    if (_existingJoinedEH >= 0) then {
        _lastGroup removeEventHandler ["UnitJoined", _existingJoinedEH];
    };

    private _existingLeftEH = _lastGroup getVariable ["vgm_c_groups_leftEH", -1];

    if (_existingLeftEH >= 0) then {
        _lastGroup removeEventHandler ["UnitLeft", _existingLeftEH];
    };

    _currentGroup setVariable ["vgm_c_groups_joinedEH", _currentGroup addEventHandler ["UnitJoined", {
        // This will not fire when a player joins the group by connecting.
        ["vgm_groups_unitJoined", _this] call para_g_fnc_event_triggerLocal;
    }]];

    _currentGroup setVariable ["vgm_c_groups_leftEH", _currentGroup addEventHandler ["UnitLeft", {
        // This will fire with unit as objNull when a player disconnects.
        ["vgm_groups_unitLeft", _this] call para_g_fnc_event_triggerLocal;
    }]];

    ["vgm_groups_left", [_lastGroup]] call para_g_fnc_event_triggerLocal;
    ["vgm_groups_joined", [_currentGroup]] call para_g_fnc_event_triggerLocal;
}];
