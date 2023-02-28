/*
    File: fn_player_set_var.sqf
    Author: Cerebral
    Date: 2023-01-03
    Last Update: 2023-01-28
    Public: No

    Description:
        This function will force a save of the player's information to the database.

    Parameter(s):
        _player - The player object to save

    Returns:
        Nothing

    Example(s):
        private _profile = [_player] call vgm_s_fnc_player_fetch;

        _profile set ["name", "Waldo"];

        [_player] call vgm_s_fnc_player_save;
 */

params ["_player"];

if (!isPlayer _player) exitWith { ["ERROR", format ["Object is not a player: %1", _player]] call para_g_fnc_log; };

private _profile = createHashMap;

// Get the player's information from mission
_profile set ["name", name _player];
_profile set ["uid", getPlayerUID _player];

private _savedData = ["player", getPlayerUID _player, _profile] call vgm_s_fnc_db_typed_save;
saveMissionProfileNamespace;

_savedData //result
