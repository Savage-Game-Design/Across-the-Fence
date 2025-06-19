/*
    File: fn_director_removeEnemyGroupFromPlayerEngagement.sqf
    Author: Savage Game Design
    Date: 2025-04-28
    Last Update: 2025-06-19
    Public: No

    Description:
        Removes a group from a player engagement.

    Parameter(s):
        _director - Mission director for the current mission [HASHMAP]
        _group - AI group to remove [GROUP]
        _player - Player whose engagement the group should be removed from [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_director, _group, _player] call vgm_s_fnc_director_removeEnemyGroupFromPlayerEngagement;
 */

params ["_director", "_group", "_player"];

private _engagement = _director get "playerEngagements" get hashValue _player;
if (isNil "_engagement") exitWith {};

_engagement get "groups" deleteAt hashValue _group;
