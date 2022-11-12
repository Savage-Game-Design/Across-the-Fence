/*
    File: fn_bf_respawn_register_respawn.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Registers a building as a respawn point
    
    Parameter(s):
		_building
    
    Returns:
		None
    
    Example(s):
*/
params ["_building"];

if !(_building getVariable ["para_s_respawn_id", []] isEqualTo []) exitWith {diag_log "Paradigm: Warning: Attempt to re-register a respawn"};

private _marker = createMarker [
    format ["building_respawn_%1", _building getVariable "para_s_building_id"],
    getPos (_building getVariable "para_g_objects" select 0)
];

_building setVariable ["para_s_respawn_marker", _marker];
//Register as a respawn position
_building setVariable ["para_s_respawn_id", 
    [west, _marker] call BIS_fnc_addRespawnPosition
];

private _handler = ["onPlayerRespawn", [{
    params ["_handlerParams", "_eventParams"];
    _handlerParams params ["_building", "_marker"];
    _eventParams params ["_player", "_identity"];

    if (_identity isEqualTo _marker) then {
        diag_log format ["Player respawned at marker %1, pos %2", _marker, markerPos _marker];
        ["RespawnedAtCheckpoint", [_player, []]] call para_g_fnc_event_dispatch;
        [_building, 50] call para_s_fnc_building_consume_supplies;
    };
}, [_building, _marker]]] call para_g_fnc_event_add_handler;

_building setVariable ["para_s_respawn_handler", _handler];