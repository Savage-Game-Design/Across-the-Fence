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
private _varsHashMap = createHashMap _vars;

if (_dbType isEqualTo "extDB3") then
{
	// Get current player variables
	private _currentVars = [_player] call vgm_s_fnc_db_get_player_vars;

	// Create HashMap from current vars
	private _currentVarsHashMap = createHashMap _currentVars;

	// Loop through vars and set them in currentVarsHashMap if the variable exists
	{
		private _var = _x;
		private _varName = _var select 0;
		private _varValue = _var select 1;

		if (_currentVarsHashMap find _varName != -1) then
		{
			_currentVarsHashMap set [_varName, _varValue];
		};
	} forEach _vars;

	// Update player query
	private _updateQuery = format ["UPDATE players SET data = '%1' WHERE uid = '%2'", _currentVarsHashMap, _uid];
}
else
{
	// Get player profile
	private _profile = profileNamespace getVariable [_uid, []];

	// Set profile to new vars
	{
		private _var = _x;
		private _value = _varsHashMap getVariable _var;

		if (_value isEqualType "") then
		{
			_profile setVariable [_var, _value];
		};
	} forEach _varsHashMap;

	// Save profile
	profileNamespace setVariable [_uid, _profile];
}