/*
	Handle player joins
*/

params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

diag_log str ["AN_ASC - PLAYER_CONNECTED: ", _this];

//Exit if Server "connects" - Don't ask... just simply don't ask...
if(_owner == 2)exitWith{};

/*
Pretty ugly way to wait, to determine if the damn player has finished his initialization, but...
it's needed... Client EH's need to be set up, to reliably receive all the data...
*/
waitUntil
{
	_getOwnerPawn = {if(owner _x isEqualTo _owner)exitWith{"done"};}forEach allPlayers;
	!isNil "_getOwnerPawn"
};

// create 32Byte TempKey, so we know which client connection belongs to which PlayerUID
private _tKey = call AN_S_fnc_key_create;

// register the connecting player in ASC
"asc_extension" callExtension ["call_function", ["user_add",[_tKey, _uid]]];

// Send the Client the command to connect to the backend directly, without calling any function on the Client!
(call AN_S_ServerData) params["_ip","_port"];
[
  [_ip,_port, _tKey, _uid],
  {
	params["_ip","_port","_tKey","_uid"];
	// also sending _uid atm - maybe for an additional check later?
	"asc_extension" callExtension ["init_client",[_ip,_port,_tKey, _uid]];
  }
] remoteExecCall ["call", _owner];