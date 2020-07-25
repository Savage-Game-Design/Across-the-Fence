/*
  Author: Aaron Clark

  Description:
	changes water and can add attributes brodcasts changes to player

  Example Usage:
      	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_ammount","_source"];

[_player,"thirst",_ammount] call vn_an_fnc_change_player_stat;

// Example: add random chance to get a diuretic attribute, todo make alcohol,caffine drinks 100% chance and lower random chance
if (random 1 < 0.1) then
{
	private _attributes = _player getVariable ["vn_an_attributes",[]];
	_attributes pushBackUnique "diuretic";
	_player setVariable ["vn_an_attributes",_attributes,[2,owner _player]];
};
