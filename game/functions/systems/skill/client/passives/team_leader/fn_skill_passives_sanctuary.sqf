/*
    File: fn_skill_passives_sanctuary.sqf
    Author: Savage Game Design
    Date: 2025-11-05
    Last Update: 2025-11-20
    Public: Yes

    Description:
        Adds or removes an action from the player that allows them to locate the nearest LZ.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_sanctuary
 */

params ["_enable"];

private _existingActionId = player getVariable ["vgm_c_skill_passives_sanctuaryAction", -1];

if (_enable && _existingActionId < 0) exitWith {
    private _actionId = player addAction [
        localize "STR_VGM_SKILLS_SKILL_SANCTUARY_ACTION",
        {
            private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
            if (isNil "_currentMission") exitWith {};
            private _lzs = [_currentMission get "targetZone"] call vgm_g_fnc_missions_zones_getLzs;
            private _playerPos = getPosATL player;
            private _nearestLz = [_lzs, _playerPos] call vgm_g_fnc_nearestPosition;
            private _spokenDirection = [_playerPos, _nearestLZ] call vgm_g_fnc_spokenDirection;
            private _distance = _playerPos distance2D _nearestLZ;

            if (_distance < 10) exitWith {
                ["Covey", localize "STR_VGM_SKILLS_SKILL_SANCTUARY_RESPONSE_NEARBY"] call BIS_fnc_showSubtitle;
            };

            private _factor = if (_distance < 100) then { 20 } else { 100 };

            private _spokenDistance = (ceil ((_playerPos distance2D _nearestLZ) / _factor)) * _factor;

            private _message = format [
                localize format ["STR_VGM_SKILLS_SKILL_SANCTUARY_RESPONSE_%1", _spokenDirection],
                _spokenDistance toFixed 0
            ];

            ["Covey", _message] call BIS_fnc_showSubtitle;
        },
        [],
        0.1,
        false,
        false,
        "",
        "true",
        -1
    ];
    player setVariable ["vgm_c_skill_passives_sanctuaryAction", _actionId];
};

if (!_enable) exitWith {
    player removeAction _existingActionId;
    player setVariable ["vgm_c_skill_passives_sanctuaryAction", -1];
};

