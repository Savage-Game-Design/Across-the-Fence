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
private _databaseType = uiNamespace getVariable ["vgm_s_database_type", "profile"];

// Create a new HashMap to return with
private _returnHashMap = createHashMap;

// Check if database type is extDB3
if (_databaseType isEqualTo "extDB3") exitWith {
    // Get player's variables from the database

    private _playerStatement = format ["SELECT data FROM players WHERE uid = '%1'", _playerUID];
    private _playerQuery = _playerStatement call vgm_s_fnc_db_query;

    private _playerVariableHashMap = createHashMapFromArray _playerQuery;

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
    } 

    // If no variables add them all
    // Add all player variables to the return HashMap
    _returnHashMap = _playerVariableHashMap;

    _returnHashMap
}
// Fallback on profileNamespace
// Get the player variables from the namespace
private _playerDataReference = format ["vgm_player_data_%1", _playerUID];
private _playerVariables = profileNamespace getVariable [_playerDataReference, createHashMap];

// Loop through the requested player variables
if (count _vars > 0) exitWith
{
    {
        // Check if the player variable exists in the database
        if (_x in _playerVariables) then {
            // Add the player variable to the return HashMap
            _returnHashMap set [_x, _playerVariables get _x];
        };
    } forEach _vars;

    _returnHashMap
} 

// Add all player variables to the return HashMap
_returnHashMap = _playerVariables;

// Return the HashMap
_returnHashMap

