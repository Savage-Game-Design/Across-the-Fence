/*
	File: fn_ai_scale_to_player_count.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Scales the AI count to the number of players in the specific teams, groups or array.
	
	Parameter(s):
		_input - Any of:
			{3} - a script, which returns a valid non-script input to this function
			[3, {_this}] - a length 2 array, where the first entry is arguments, and second entry is a script as defined above
			[player] - An array of objects, uses the length of the array
			number - Uses the number
			[String|String[]|Object[]|Code]
		_scaleFactor - Number to scale by. '1' is considered a reasonable number of opponents for the players. 2 is twice as many, etc [Number]
	
	Returns: nothing
	
	Example(s): none
*/

params ["_input", "_scaleFactor"];

//Always 1 unit if we've got the AI quantity in debug mode
if (para_g_enemiesPerPlayer == 0) exitWith { 
	1 
};

private _playerCount = 0;

//Script with arguments
if (_input isEqualType {}) then {
	_input = call _input;
};

//Script with arguments
if (_input isEqualType [] && {count _input == 2 && {_input select 1 isEqualType {}}}) then {
	_input = (_input # 0) call (_input # 1);
};

if (_input isEqualType []) then {
	_playerCount = count _input;
};

if (_input isEqualType 0) then {
	_playerCount = _input;
};

//Always at least 1! Otherwise things break because things don't spawn, divide by 0, etc.
_playerCount = _playerCount max 1;

ceil (_playerCount * _scaleFactor * para_g_enemiesPerPlayer);

