/*
    File: eh_PreloadFinished.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-05-27
    Public: No

    Description:
	    Preload finished event handler with self destruct.

    Parameter(s): none

    Returns: nothing

    Example(s):
	    Not called directly.
*/

#include "..\..\config\defines.hpp"

private _target_scope = call para_g_fnc_custom_scope;

// start game for headed clients
if (_target_scope in [HEADED_CLIENT_HOST,HEADED_CLIENT]) then vn_an_fnc_start_game_client;

// HEADLESS client code start
if (_target_scope in [HEADLESS_CLIENT]) then vn_an_fnc_start_game_headless;


["PreloadFinished mEH: %1", _this] call BIS_fnc_logFormat;

// self destruct EH
removeMissionEventHandler ["PreloadFinished",_thisEventHandler ];
