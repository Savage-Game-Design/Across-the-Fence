/*
	send request to the Server to get loot for targeted object.
	WIP! Needs wayyyy more counter-checks
*/
#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

_tgt = cursorObject;
// diag_log ["_tgt: ", _tgt];

// if(!isSimpleObject _tgt)exitWith{systemChat "DEBUG MSG: LOOT_INV_REQUEST: No Object found.";};
if(player distance _tgt > 5)exitWith{systemChat "DEBUG MSG: LOOT_INV_REQUEST: Too far away.";};

private _building = _tgt getVariable ["linked_building",objNull];
private _pos = _tgt getVariable ["linked_pos",[0,0,0]];

// "send re to server to loot object with ref to crate object and crate pos and building item is spawned in"
[player,'crate_loot_request',[_pos,_building],player getVariable 'para_player_token'] remoteExecCall ['para_s_fnc_rehandler',2];
