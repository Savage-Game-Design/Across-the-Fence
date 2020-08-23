/*
	send request to the Server to get loot for targeted object.
	WIP! Needs wayyyy more counter-checks (e.g. if the crate is a legit loot container)
*/
#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

_tgt = cursorObject;
diag_log ["_tgt: ", _tgt];

if(!isSimpleObject _tgt)exitWith{systemChat "DEBUG MSG: LOOT_INV_REQUEST: No Object found.";};
if(player distance _tgt > 3)exitWith{systemChat "DEBUG MSG: LOOT_INV_REQUEST: Too far away.";};

diag_log ["getPosWorld _tgt: ", getPosWorld _tgt];
[getPosWorld _tgt] remoteExecCall ["AN_S_fnc_crate_loot_request", 2];
