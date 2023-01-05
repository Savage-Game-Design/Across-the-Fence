/*
    File: fn_player_set_var.sqf
    Author: Cerebral
    Date: 2023-01-03
    Last Update: 2023-01-04
    Public: No

    Description:
        This function will force a save of the player's information to the database.

        This shouldn't be required since the information is a reference to
            the missionNamespace object, but it's here just in case.

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

private _playerProfile = [_player] call vgm_s_fnc_player_fetch;
["player", getPlayerUID _player, _playerProfile] call vgm_s_fnc_db_typed_save;
saveMissionProfileNamespace;
