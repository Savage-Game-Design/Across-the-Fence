/*
    File: fn_db_get_player_vars.sqf
    Author: Cerebral
    Date: 2022-11-03
    Last Update: 
    Public: No

    Description:
        Gets the player's variables from the database.

    Parameter(s):
        0: Player - Player to get the variables from. (Default: player)    
            Example - player

        1: Array - Array of variable names to get from the database. (Default: []) 
            Example - ["var1", "var2", "var3"]

    Returns: HashMap

    Example(s):
        [player, ["var1", "var2", "var3"]] call vgm_s_fnc_db_get_player_vars;
        
*/

params ["_vars"];

// Check if playerVars is null, empty, or isn't an array.
if (isNull _vars || {_vars isEqualTo []} || {!(_vars isEqualType [])}) then
{
    // create empty array for playerVars
    _vars = [];
};

// Get player's UID
private _playerUID = getPlayerUID player;

// Check database type
private _databaseType = uiNamespace getVariable ["vgm_s_db_type", "profile"];

// Create a new HashMap to return with
private _returnHashMap = createHashMap;

// Check if database type is extDB3
if (_databaseType isEqualTo "extDB3") exitWith {
    // Get player's variables from the database

    private _playerStatement = format ["SELECT data FROM players WHERE uid = '%1'", _playerUID];
    private _playerQuery = [_playerStatement, 2] call vgm_s_fnc_db_query;

    // Turn query into HashMap
    private _queryArray = _playerQuery select 1 select 0 select 0; // Data comes out like [[[["var1", "value1"], ["var2", "value2"]]]]
    private _playerVariableHashMap = createHashMapFromArray _queryArray;

    // Loop through the requested player variables
    if (count _vars > 0) exitWith {
        {
            // Check if the player variable exists in the database
            if (_x in _playerVariableHashMap) then {
                // Add the player variable to the return HashMap
                _returnHashMap set [_x, _playerVariableHashMap get _x];
            };
        } forEach _vars;

        _returnHashMap
    };

    // Ensure return type is a HashMap
    if (!(_playerVariableHashMap isEqualType _returnHashMap)) exitWith {
        // Return empty HashMap
        _returnHashMap;
    };

    // If no variables return them all
    _playerVariableHashMap
};

// Fallback on profileNamespace
// Get player data from profileNamespace
private _playerData = profileNamespace getVariable ["vgm_player_data", createHashMap];

// Get player data version from vgm_player_data
if (isNil (_playerData get "version")) then
{
    // Set player data version to VGM_VERSION
    _playerData set ["version", VGM_VERSION];
};

// Get profile from player data
private _profile = _playerData get [_playerUID, createHashMap];

// Loop through the requested player variables
if (count _vars > 0) exitWith
{
    {
        // Check if the player variable exists in the database
        if (_x in _profile) then {
            // Add the player variable to the return HashMap
            _returnHashMap set [_x, _profile get _x];
        };
    } forEach _vars;

    _returnHashMap
};

// Add all player variables to the return HashMap
_profile;


