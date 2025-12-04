/*
    File: fn_skill_passives_rallyPoint.sqf
    Author: Savage Game Design
    Date: 2025-11-05
    Last Update: 2025-12-04
    Public: Yes

    Description:
        Adds or removes the "Set rally point" action from the player.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_rallyPoint
 */

#define PLACEMENT_DISTANCE 5

params ["_enable"];

private _existingActionId = player getVariable ["vgm_c_skill_passives_rallyPointAction", -1];

if (_enable && _existingActionId < 0) exitWith {
    private _actionId = player addAction [
        localize "STR_VGM_SKILLS_SKILL_RALLY_POINT_ACTION",
        {
            private _mission = [] call vgm_c_fnc_missions_getCurrentMission;
            if (isNil "_mission") exitWith {};

            private _missionId = _mission get "id";

            if ("rallyPosATL" in (_mission get "system_respawn")) exitWith {
                [_missionId] remoteExecCall ["vgm_s_fnc_respawn_clearMissionRallyPoint", 2];
                createHashMapFromArray [
                    ["title", "STR_VGM_SKILLS_SKILL_RALLY_POINT"],
                    ["body", "STR_VGM_SKILLS_SKILL_RALLY_POINT_CLEARED"]
                ] remoteExecCall ["vgm_c_fnc_postNotification", units group player];
            };

            private _origin = AGLtoASL positionCameraToWorld [0, 0, 0];
            private _dest = _origin vectorAdd (getCameraViewDirection player vectorMultiply PLACEMENT_DISTANCE);
            private _lookIntersections = lineIntersectsSurfaces [
                _origin,
                _dest,
                focusOn,
                curatorCamera,
                true,
                1,
                "FIRE"
            ];

            private _rallyPointATL = _origin getPos [ PLACEMENT_DISTANCE, (_origin getDir _dest) ];

            if (_lookIntersections isNotEqualTo []) then {
                private _intersectPosASL = _lookIntersections # 0 # 0;
                private _vectorDelta = _intersectPosASL vectorDiff _origin;
                private _vectorDeltaMagnitude = vectorMagnitude _vectorDelta;
                // Too close to the object - use the player's position, as it must be safe.
                if (_vectorDeltaMagnitude < 1) exitWith {
                    _rallyPointATL = getPosATL player;
                };

                private _rallyPointASL = _origin vectorAdd (_vectorDelta vectorMultiply ( (_vectorDeltaMagnitude - 1) / _vectorDeltaMagnitude ));
                _rallyPointATL = ASLtoATL _rallyPointASL;
            };

            // Make sure rally point is just slightly above the ground.
            _rallyPointATL set [2, 0.1];

            [_missionId, _rallyPointATL] remoteExecCall ["vgm_s_fnc_respawn_setMissionRallyPoint", 2];

            [
                createHashMapFromArray [
                    ["id", "vgm_skills_rallyPoint_" + str _missionId],
                    ["expires", serverTime + 5],
                    ["position", _rallyPointATL],
                    //["texture", "\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa"],
                    ["texture", "\A3\ui_f\data\map\markers\handdrawn\flag_CA.paa"],
                    ["color", [1,0,0.3,0.9]],
                    ["size", 2],
                    ["text", "STR_VGM_SKILLS_SKILL_RALLY_POINT_SET"],
                    ["alwaysVisible", true],
                    ["fadeWhenNotVisible", true]
                ]
            ] remoteExecCall ["vgm_c_fnc_posIndicators_create", units group player];
        },
        [],
        0.1,
        false,
        false,
        "",
        "true",
        -1
    ];
    player setVariable ["vgm_c_skill_passives_rallyPointAction", _actionId];
};

if (!_enable) exitWith {
    player removeAction _existingActionId;
    player setVariable ["vgm_c_skill_passives_rallyPointAction", -1];
};

