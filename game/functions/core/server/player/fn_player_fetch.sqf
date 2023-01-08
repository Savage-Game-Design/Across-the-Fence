/*
    File: fn_player_get_fetch.sqf
    Author: Cerebral
    Date: 2023-01-03
    Last Update: 2023-01-08
    Public: No

    Description:
        Gets the player profile from the database. If the profile does not exist, it will be created.

    Parameter(s):
        _player [PLAYER] - The player object to get the profile for.

    Returns:
        _profile [HASHMAP]

    Example(s):
        private _profile = [_player] call vgm_s_fnc_player_fetch;

        _profile set ["name", "Waldo"];
 */

params ["_player"];

if (!isPlayer _player) exitWith {
    ["ERROR", format ["%1 is not a player object", _player]] call para_g_fnc_log;
};

private _profile = ["player", getPlayerUID _player] call vgm_s_fnc_db_get;

_profile //result
