/*
    File: fn_post_init.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-01-29
    Public: No

    Description:
        Executes the post init routine.

    Parameter(s): none

    Returns: nothing

    Example(s): none
*/

#include "..\..\config\defines.hpp"

// determine what type of client or server we are dealing with
_target_scope = call para_g_fnc_custom_scope;

_target_scope call para_g_fnc_init_mission_handlers;


if (_target_scope in [HEADED_CLIENT_HOST,HEADED_CLIENT]) then
{
	cutText ["","BLACK FADED",0];
};


// start server on host or dedicated
if (_target_scope in [HEADED_CLIENT_HOST,DEDICATED_SERVER]) then vn_an_fnc_start_game_server;
