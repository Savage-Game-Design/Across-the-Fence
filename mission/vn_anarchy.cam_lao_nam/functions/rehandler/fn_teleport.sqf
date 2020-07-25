/*
  Author: Aaron Clark

  Description:
	moves player to another camp or location

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_location","_agent"];

// make sure player is witin 20m of a duty officer
if !(vn_an_duty_officers inAreaArray [getPos _player, 20, 20, 0, false, 20] isEqualTo []) then
{
	// teleport player to nearby location
	private _new_location = _location findEmptyPosition [3,30,typeOf _player];
	if !(_new_location isEqualTo []) then
	{
		_location = _new_location;
	};

	remoteExecCall ["vn_an_fnc_display_location_time",_player];

	_player setpos _location;
};
