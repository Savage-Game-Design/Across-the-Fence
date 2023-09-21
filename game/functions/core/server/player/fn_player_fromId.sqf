/*
    File: fn_player_fromId.sqf
    Author: Savage Game Design
    Date: 2023-09-21
    Last Update: 2023-09-21
    Public: Yes

    Description:
        Get player object from DirectPlay ID.

    Parameter(s):
        _playerId - Player id [NUMBER]

    Returns:
        Player [OBJECT]

    Example(s):
        0 call vgm_s_fnc_player_fromId
 */

params [
    ["_playerId", "", [""]]
];

getUserInfo _playerId param [10, objNull] // return
