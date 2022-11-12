/*
    File: fn_init_server.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Initialises the server as part of Paradigm's init process.
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
		//description.ext
		use_paradigm_init = 1;
*/

if (!isServer) exitWith {};
if (getNumber (missionConfigFile >> "use_paradigm_init") <= 0) exitWith {};

//Spawn so we don't hold up the postInit process.
[] spawn {
	private _fnc_initServer = compile preprocessFile "para_server_init.sqf";
	diag_log "Paradigm: Server detected. Waiting for initFunctions before beginning init.";
	waitUntil {uiSleep 0.2;	missionNamespace getVariable ["bis_fnc_init", false]};
	diag_log "Paradigm: initFunctions completed, beginning init.";
	private _startTime = diag_tickTime;
	[] call _fnc_initServer;
	diag_log format ["Paradigm: Serverside initialisation completed in %1 seconds", (diag_tickTime - _startTime) toFixed 1];
	para_server_init_completed = true;
	publicVariable "para_server_init_completed";
};
