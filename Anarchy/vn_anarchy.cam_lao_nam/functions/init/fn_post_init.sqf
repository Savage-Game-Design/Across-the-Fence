#include "..\..\config\defines.hpp"

// determine what type of client or server we are dealing with
_target_scope = call vn_mf_fnc_custom_scope;

_target_scope call vn_mf_fnc_init_mission_handlers;

// start server on host or dedicated
if (_target_scope in [HEADED_CLIENT_HOST,DEDICATED_SERVER]) then vn_mf_fnc_start_game_server;
