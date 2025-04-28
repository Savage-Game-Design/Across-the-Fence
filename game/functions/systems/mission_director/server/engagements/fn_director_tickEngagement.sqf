/*
    File: fn_director_tickEngagement.sqf
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

params ["_director", "_engagement"];

private _player = _engagement get "player";

if (!alive _player) exitWith {
    [_director, _engagement] call vgm_s_fnc_director_deleteEngagement;
};

private _groupsMap = _engagement get "groups";
private _invalidGroupHashes = [];
{
    private _everyoneDead = units _y findIf { lifeState _x in ["HEALTHY", "INJURED"] } == -1;
    private _playerNotTargeted = !(_player in (_y getVariable ["vgm_g_ai_targets", []]));
    if (_everyoneDead || _playerNotTargeted) then {
        _invalidGroupHashes pushBack _x;
    };
} forEach _groupsMap;

{
    _groupsMap deleteAt _x;
} forEach _invalidGroupHashes;


if (count _groupsMap == 0) exitWith {
    [_director, _engagement] call vgm_s_fnc_director_deleteEngagement;
};

