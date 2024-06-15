/*
    File: fn_missions_makeMissionGiver.sqf
    Author:
    Date: 2023-04-23
    Last Update: 2024-04-04
    Public: Yes

    Description:
        Makes an object into a mission giver.

        This is intended for debug use only.

    Parameter(s):
        _object - Object to make into a mission giver [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorObject] call vgm_c_fnc_missions_makeMissionGiver;
 */

// THIS IS INTENDED FOR DEBUG USE
// Therefore the code is pretty rough. Sorry.

params ["_object"];

_object setVariable ["vgm_c_missions_joinActions", createHashMap];

// Add action to create mission
_object addAction [
    "Create mission",
    {
        private _targetZone = selectRandom vgm_missions_zones_targetBoxes ;
        [getPlayerID player, _targetZone] remoteExec ["vgm_s_fnc_missions_remoteExec_createMission", 2];
    },
    [],
    100,
    false,
    true,
    "",
    "isNil { call vgm_c_fnc_missions_getCurrentMission }",
    10
];

vgm_c_fnc_addJoinMissionAction = {
    params ["_missionId", "_object"];

    private _actionId = _object addAction [
        format ["Join mission %1", _missionId],
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_missionId"];

            [getPlayerID player, _missionId] remoteExec ["vgm_s_fnc_missions_remoteExec_joinMission", 2];
        },
        [_missionId],
        90,
        false,
        true,
        "",
        "true",
        10
    ];

    _object getVariable "vgm_c_missions_joinActions" set [_missionId, _actionId];
};

vgm_c_fnc_addAllJoinMissionActions = {
    params ["_object"];

    private _missions = ([] call vgm_c_fnc_missions_getMissions) call para_g_fnc_netmap_values;
    private _joinableMissions = _missions select {
        ((_x get "preventJoining") call para_g_fnc_netmap_count) == 0
    };

    // Add actions to join joinable missions
    {
        [_x get "id", _object] call vgm_c_fnc_addJoinMissionAction;
    } forEach _joinableMissions;
};

vgm_c_fnc_addLeaveMissionAction = {
    params ["_object"];

    // Add action to leave mission
    private _leaveMissionActionId = _object addAction [
        "Leave mission",
        {
            params ["_target", "_caller", "_actionId", "_arguments"];

            [getPlayerID player] remoteExec ["vgm_s_fnc_missions_remoteExec_leaveMission", 2];
        },
        [],
        110,
        false,
        true,
        "",
        "true",
        10
    ];

    _object setVariable ["vgm_c_missions_leaveAction", _leaveMissionActionId];
};

vgm_c_fnc_removeLeaveMissionAction = {
    params ["_object"];

    private _actionId = _object getVariable "vgm_c_missions_leaveAction";
    if (isNil "_actionId") exitWith {};

    _object removeAction _actionId;
    _object setVariable ["vgm_c_missions_leaveAction", nil];
};

vgm_c_fnc_addStartMissionAction = {
    params ["_object"];

    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission" || { _currentMission get "creator" isNotEqualTo getPlayerID player }) exitWith {};

    // Add action to start mission
    private _startMissionActionId = _object addAction [
        "Start mission",
        {
            params ["_target", "_caller", "_actionId", "_arguments"];

            [getPlayerID player] remoteExec ["vgm_s_fnc_missions_remoteExec_startMission", 2];
        },
        [],
        105,
        false,
        true,
        "",
        "!(isNil { call vgm_c_fnc_missions_getCurrentMission})",
        10
    ];

    _object setVariable ["vgm_c_missions_startAction", _startMissionActionId];
};

vgm_c_fnc_removeStartMissionAction = {
    params ["_object"];

    private _actionId = _object getVariable "vgm_c_missions_startAction";
    if (isNil "_actionId") exitWith {};

    _object removeAction _actionId;
    _object setVariable ["vgm_c_missions_startAction", nil];
};

vgm_c_fnc_removeJoinMissionAction = {
    params ["_missionId", "_object"];

    private _joinActions = _object getVariable "vgm_c_missions_joinActions";
    private _actionId = _joinActions get _missionId;
    if (isNil "_actionId") exitWith {};

    _object removeAction _actionId;
    _joinActions deleteAt _missionId;
};

vgm_c_fnc_removeAllJoinMissionActions = {
    params [ "_object"];

    private _joinActions = _object getVariable "vgm_c_missions_joinActions";

    {
        [_x, _object] call vgm_c_fnc_removeJoinMissionAction;
    } forEach (keys _joinActions);
};

[
    "vgm_mission_notJoinable",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        [_missionId, _object] call vgm_c_fnc_removeJoinMissionAction;
    }]
] call para_g_fnc_event_subscribeServer;

[
    "vgm_mission_joinable",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        [_missionId, _object] call vgm_c_fnc_addJoinMissionAction;
    }]
] call para_g_fnc_event_subscribeServer;

[
    "vgm_mission_attached",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_playerId", "_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        if (_playerId isEqualTo getPlayerID player) then {
            [_object] call vgm_c_fnc_removeAllJoinMissionActions;
            [_object] call vgm_c_fnc_addStartMissionAction;
            [_object] call vgm_c_fnc_addLeaveMissionAction;
        };

    }]
] call para_g_fnc_event_subscribeServer;

[
    "player removed from mission",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_playerId", "_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        if (_playerId isEqualTo getPlayerID player) then {
            [_object] call vgm_c_fnc_addAllJoinMissionActions;
            [_object] call vgm_c_fnc_removeStartMissionAction;
            [_object] call vgm_c_fnc_removeLeaveMissionAction;
        };
    }]
] call para_g_fnc_event_subscribeServer;

[
    "vgm_mission_ended",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
        if (!isNil "_currentMission" && { _currentMission get "id" isEqualTo _missionId }) then {
            [_object] call vgm_c_fnc_addAllJoinMissionActions;
            [_object] call vgm_c_fnc_removeStartMissionAction;
            [_object] call vgm_c_fnc_removeLeaveMissionAction;
        };
    }]
] call para_g_fnc_event_subscribeServer;

[
    "vgm_mission_started",
    [[_object], {
        params ["_eventData", "_savedParameters"];
        _eventData params ["_missionId"];
        _savedParameters params ["_object"];

        if (isNull _object) exitWith {
            // TODO - Remove handler if object no longer exists.
        };

        if (_missionId isEqualTo (([] call vgm_c_fnc_missions_getCurrentMission) get "id")) then {
            [_object] call vgm_c_fnc_removeStartMissionAction;
            [_object] call vgm_c_fnc_removeLeaveMissionAction;
        };
    }]
] call para_g_fnc_event_subscribeServer;

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

if (isNil "_currentMission") then {
    [_object] call vgm_c_fnc_addAllJoinMissionActions;
} else {
    [_object] call vgm_c_fnc_addStartMissionAction;
    [_object] call vgm_c_fnc_addLeaveMissionAction;
};
