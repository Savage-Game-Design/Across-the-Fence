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
    private _currentVars = [_player, []] call vgm_s_fnc_db_get_player_vars;

    // Create HashMap if currentVars is nil
    if (isNil "_currentVars") then
    {
        _currentVars = createHashMap;
    };
    
    // Loop through vars and set them in currentVarsHashMap
    {
        _currentVars set [_x select 0, _x select 1];
    } forEach _vars;

    diag_log format ["VGM: Setting player variables for %1 with %2", _uid, _currentVars];

    // Update player query
    private _updateQuery = format ["UPDATE players SET data = '%1' WHERE uid = '%2'", _currentVars, _uid];

    // Execute query
    [_updateQuery, 1] call vgm_s_fnc_db_query;
};

// Get player data from profileNamespace
private _playerData = profileNamespace getVariable ["vgm_player_data", createHashMap];

// Get player data version from vgm_player_data
if (isNil (_playerData get "version")) then
{
    // Set player data version to VGM_VERSION
    _playerData set ["version", VGM_VERSION];
};

private _profile = _playerData get [_uid, createHashMap];

// Set profile variables to vars
{
    _profile set [_x select 0, _x select 1];
} forEach _vars;

// Save player data
profileNamespace setVariable ["vgm_player_data", _playerData];
