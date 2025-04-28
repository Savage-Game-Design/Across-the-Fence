/*
    File: fn_director_addEnemyGroupToPlayerEngagement.sqf
    Author:
    Date: 2025-04-28
    Last Update: 2025-04-28
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_director", "_group", "_player"];

if (isNull _player) exitWith {};
private _engagement = _director get "playerEngagements" getOrDefaultCall [
    hashValue _player,
    { [_director, _player] call vgm_s_fnc_director_createEngagement },
    true
];

_engagement get "groups" set [hashValue _group, _group];
