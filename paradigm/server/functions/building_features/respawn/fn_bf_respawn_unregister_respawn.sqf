/*
    File: fn_bf_respawn_unregister_respawn.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Removes a building as a respawn point.
    
    Parameter(s):
        _building - Building to unregister [OBJECT]
    
    Returns:
		None
    
    Example(s):
		
*/

params ["_building"];

private _respawnId = _building getVariable ["para_s_respawn_id", []];
if (_respawnId isEqualTo []) exitWith {diag_log "Paradigm: Warning: Attempt to unregister a respawn that isn't registered."};
//Remove respawn position
(_building getVariable "para_s_respawn_id") call BIS_fnc_removeRespawnPosition;
_building setVariable ["para_s_respawn_id", nil];

deleteMarker (_building getVariable "para_s_respawn_marker");

["onPlayerRespawn", _building getVariable "para_s_respawn_handler"] call para_g_fnc_event_remove_handler;