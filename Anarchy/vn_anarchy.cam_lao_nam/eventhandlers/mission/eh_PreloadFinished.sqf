/*
  Author: Aaron Clark

  Description:
	preload finished with self destruct

*/
#include "..\..\config\defines.hpp"

private _target_scope = call vn_an_fnc_custom_scope;

// start game for headed clients
if (_target_scope in [HEADED_CLIENT_HOST,HEADED_CLIENT]) then vn_an_fnc_start_game_client;

// HEADLESS client code start
if (_target_scope in [HEADLESS_CLIENT]) then vn_an_fnc_start_game_headless;

// self destruct EH
removeMissionEventHandler ["PreloadFinished",_thisEventHandler ];
