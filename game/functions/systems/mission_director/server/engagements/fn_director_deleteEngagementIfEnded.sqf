/*
    File: fn_director_deleteEngagementIfEnded.sqf
    Author: Savage Game Design
    Date: 2025-04-28
    Last Update: 2025-06-19
    Public: No

    Description:
        Updates the groups involved in an engagement, and deletes an engagement if it has ended.

        An group is in an engagement if:
            - It has living units
            - It is targeting the engaged player

        An engagement is ended when:
            - The player is dead
            - No groups are engaged with the player

    Parameter(s):
        _director - Mission director for the current mission [HASHMAP]
        _engagement - Engagement to check [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_director, _engagement] call vgm_s_fnc_director_deleteEngagementIfEnded;
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

