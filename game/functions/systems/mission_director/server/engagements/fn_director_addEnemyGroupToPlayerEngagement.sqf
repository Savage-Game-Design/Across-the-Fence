/*
    File: fn_director_addEnemyGroupToPlayerEngagement.sqf
    Author: Savage Game Design
    Date: 2025-04-28
    Last Update: 2025-06-19
    Public: Yes

    Description:
        Adds an enemy group to an engagement with the player.

        They may be automatically removed by `deleteEngagementIfEnded` if they aren't a valid group.

    Parameter(s):
        _director - Mission director for the current mission [HASHMAP]
        _group - AI group to add
        _player - Player that's being targeted

    Returns:
        Nothing

    Example(s):
        ["vgm_ai_groupTargetsEngaged", {
            (_this # 0) params ["_group", "_targets"];

            private _missionId = _group getVariable "vgm_g_missionId";
            private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
            if (isNil "_director") exitWith {};
            {
                [_director, _group, _x] call vgm_s_fnc_director_addEnemyGroupToPlayerEngagement;
            } forEach _targets;
        }] call para_g_fnc_event_subscribe;
 */

params ["_director", "_group", "_player"];

if (isNull _player) exitWith {};
private _engagement = _director get "playerEngagements" getOrDefaultCall [
    hashValue _player,
    { [_director, _player] call vgm_s_fnc_director_createEngagement },
    true
];

_engagement get "groups" set [hashValue _group, _group];
