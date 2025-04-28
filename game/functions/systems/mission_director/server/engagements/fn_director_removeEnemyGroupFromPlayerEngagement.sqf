/*
    File: fn_director_removeEnemyGroupFromPlayerEngagement.sqf
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

private _engagement = _director get "playerEngagements" get hashValue _player;
if (isNil "_engagement") exitWith {};

_engagement get "groups" deleteAt hashValue _group;
