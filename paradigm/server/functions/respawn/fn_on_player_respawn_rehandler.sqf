/*
    File: fn_on_player_respawn_rehandler.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Called by the client when a player respawns using the respawn menu.
    
    Parameter(s):
        _identity - Identity of the location respawned at.
    
    Returns:
		None
    
    Example(s):
		["on_player_respawn", _identity] call para_c_fnc_spawn_on_server;
*/

params ["_identity"];

["onPlayerRespawn", [_player, _identity]] call para_g_fnc_event_dispatch_immediate;