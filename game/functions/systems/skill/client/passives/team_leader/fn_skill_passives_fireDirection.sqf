/*
    File: fn_skill_passives_fireDirection.sqf
    Author: Savage Game Design
    Date: 2025-11-05
    Last Update: 2025-12-14
    Public: Yes

    Description:
        Adds or removes the "fire direction" action from the player.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_fireDirection
 */

params ["_enable"];

private _existingActionId = player getVariable ["vgm_c_skill_passives_fireDirectionAction", -1];
private _isCorrectAction = player actionParams _existingActionId select 0 == localize "STR_VGM_SKILLS_SKILL_FIRE_DIRECTION_ACTION";

if (_enable && (_existingActionId < 0 || !_isCorrectAction)) exitWith {
    private _actionId = player addAction [
        localize "STR_VGM_SKILLS_SKILL_FIRE_DIRECTION_ACTION",
        {
            private _origin = AGLtoASL positionCameraToWorld [0, 0, 0];
            private _dest = _origin vectorAdd (getCameraViewDirection player vectorMultiply 1000);
            private _lookIntersections = lineIntersectsSurfaces [
                _origin,
                _dest,
                focusOn,
                curatorCamera,
                true,
                1,
                "FIRE"
            ];

            if (_lookIntersections isEqualTo []) exitWith {};

            private _indicatorPos = ASLtoATL (_lookIntersections # 0 # 0);
            _indicatorPos = _indicatorPos vectorAdd ((_lookIntersections # 0 # 1) vectorMultiply 0.25);

            [
                createHashMapFromArray [
                    ["id", "vgm_skills_fireDirection_" + getPlayerUID player],
                    ["expires", serverTime + 15],
                    ["position", _indicatorPos],
                    //["texture", "\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa"],
                    ["texture", "\A3\ui_f\data\map\markers\handdrawn\objective_CA.paa"],
                    ["color", [0.39,0.8,0.88,0.75]],
                    ["size", 1],
                    ["text", name player],
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
    player setVariable ["vgm_c_skill_passives_fireDirectionAction", _actionId];
};

if (!_enable) exitWith {
    player removeAction _existingActionId;
    player setVariable ["vgm_c_skill_passives_fireDirectionAction", -1];
};

