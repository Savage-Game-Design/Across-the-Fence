/*
    File: fn_player_set_var.sqf
    Author: Cerebral
    Date: 2023-01-03
    Last Update: 2023-01-03
    Public: No

    Description:
        This function will force a save of the player's profile to the database.

        This shouldn't be required since the profile is a reference to
            the missionNamespace object, but it's here just in case.

    Parameter(s):
        _playerProfile - The player's profile [HASHMAP]

    Returns:
        Nothing

    Example(s):
        private _profile = [player] call vgm_s_fnc_player_get_profile;

        _profile set ["name", "Waldo"];

        [_profile] call vgm_s_fnc_player_save;
 */

params ["_playerProfile"];

// Ensure that _playerProfile is a hashmap and it has a uid
if (typeName _playerProfile != "HASHMAP" || isNil _playerProfile get "uid") exitWith {
    ["ERROR", format ["Invalid player profile: %1", _playerProfile]] call para_g_fnc_log;
    false
};

["player", getPlayerUID player, _playerProfile] call vgm_s_fnc_db_typed_save;
