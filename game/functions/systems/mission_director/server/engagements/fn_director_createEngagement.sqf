/*
    File: fn_director_createEngagement.sqf
    Author: Savage Game Design
    Date: 2025-04-28
    Last Update: 2025-04-28
    Public: No

    Description:
        Creates a new engagement for the given player.
        Engagements track conflicts between a player and a set of AI groups.

        Engagements last until either the player has exited combat or is killed, or until all enemy groups
        have left the engagement or are killed.

    Parameter(s):
        _player - Player that owns the engagement [Unit]

    Returns:
        Engagement [HashMap]

    Example(s):
        [_player] call vgm_s_fnc_director_createEngagement;
 */

params ["_director", "_player"];

private _engagement = createHashMapFromArray [
    ["player", _player],
    // Save in case player entity is deleted
    ["playerHash", hashValue _player],
    // Use a hashmap as an array would require pushBackUnique.
    // That would be fine for most missions, but would become a performance issue if custom mission makers increase max group count.
    ["groups", createHashMap],
    ["startedAt", serverTime],
    ["ended", false]
];

_director get "playerEngagements" set [_engagement get "playerHash", _engagement];

_engagement
