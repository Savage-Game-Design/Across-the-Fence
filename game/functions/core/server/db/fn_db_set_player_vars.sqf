/*
    File: fn_db_set_player_vars.sqf
    Author: Cerebral
    Date: 2022-11-03
    Last Update: 
    Public: No

    Description:
        Sets the player variables for the given player.

    Parameter(s):
        0: Player - Player to get the variables from. (Default: player)    
            Example - player

        1: HashMap - HashMap of variables to set.
            Example - [["var1", 1], ["var2", 2]]

    Returns: nothing

    Example(s):
        [player, [["var1", 1], ["var2", 2]]] call vgm_s_fnc_db_set_player_vars;
        
*/

params ["_player", "_vars"];

// Get database type
private _dbType = call vgm_s_fnc_db_get_type;

// Get player uid
private _uid = getPlayerUID _player;

// Create HashMap from vars
private _varsHashMap = createHashMapFromArray _vars;

if (_dbType isEqualTo "extDB3") exitWith
{
    // Get current player variables
    private _currentVars = [_player] call vgm_s_fnc_db_get_player_vars;

    // Loop through vars and set them in currentVarsHashMap
    {
        _currentVars set [_x select 0, _x select 1];
    } forEach _vars;

    // Update player query
    private _updateQuery = format ["UPDATE players SET data = '%1' WHERE uid = '%2'", _currentVars, _uid];

    // Execute query
    _updateQuery call vgm_s_fnc_db_query;
}

// Fallback on profile
// Get player profile
private _playerDataReference = format ["vgm_player_data_%1", _playerUID];
private _profile = profileNamespace getVariable [_playerDataReference, createHashMap];

// Set profileHashMap variables to vars
{
    _profile set [_x select 0, _x select 1];
} forEach _vars;

// Save profile
profileNamespace setVariable [_playerDataReference, _profile];
