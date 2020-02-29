/*
  Author: Aaron Clark

  Description:
	changes food and brodcasts changes to player

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_ammount","_source"];
[_player,"hunger",_ammount] call vn_mf_fnc_change_player_stat;
