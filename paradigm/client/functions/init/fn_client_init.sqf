/*
    File: fn_client_init.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Starts the paradigm init process on the client.
		Alternates between performing init, and waiting for the server to perform init.
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

if (getNumber (missionConfigFile >> "use_paradigm_init") <= 0) exitWith {};
if (isServer && !hasInterface) exitWith {};

addMissionEventHandler ["PreloadFinished", {
	para_c_preload_finished = true;
	removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
}];

//Spawn it so we don't block player loading by holding up postInit.
[] spawn {
	diag_log "Paradigm: Client init started";
	private _fnc_preload = compile preprocessFile "para_player_preload_client.sqf";
	private _fnc_loaded = compile preprocessFile "para_player_loaded_client.sqf";
	private _fnc_initClient = compile preprocessFile "para_player_init_client.sqf";

	waitUntil {!isNull findDisplay 46};

	diag_log "Paradigm: Preload started";

	[] call _fnc_preload;

	//Wait for the player to be ready.
	//There's more checks than we need in here, but better safe than sorry.
	waitUntil {
		uiSleep 0.1;
		//After pre-load is completed (all functions initialised)
		missionNamespace getVariable ["bis_fnc_init", false] 
		//No loading screens
		&& !(call BIS_fnc_isLoading)
		//After briefing
		&& getClientStateNumber >= 10
		//Player object created
		&& !isNull player
		//Preload finished
		&& !isNil "para_c_preload_finished"
	};

	diag_log "Paradigm: Player finished loading";

	[player, didJIP] call _fnc_loaded;

	diag_log "Paradigm: Player ready, waiting for server to be ready.";

	private _timeout = diag_tickTime + 360;

	waitUntil {
		uiSleep 0.1;
		diag_tickTime > _timeout || !isNil "para_server_init_completed"
	};

	if (diag_tickTime > _timeout) exitWith {
		diag_log "Paradigm: Client init timed out waiting for server to initialise.";
		//End the loading screen, so we don't get stuck.
		endLoadingScreen;
		["Broken Init", false] call BIS_fnc_endMission;
	};

	diag_log "Paradigm: Initialising player on server";
	[player, didJIP] remoteExec ["para_s_fnc_init_player", 2];

	_timeout = diag_tickTime + 15;

	waitUntil {uiSleep 0.1; diag_tickTime > _timeout || !isNil "para_player_initialised"};

	if (diag_tickTime > _timeout) exitWith {
		diag_log "Paradigm: Client init timed out waiting for server response.";
		//End the loading screen, so we don't get stuck.
		endLoadingScreen;
		["Broken Init", false] call BIS_fnc_endMission;
	};

	diag_log "Paradigm: Initialising player on client";
	[player, didJIP] call _fnc_initClient;


	diag_log "Paradigm: Player initialised on client. Running postinit on server";
	[player, didJIP] remoteExec ["para_s_fnc_postinit_player", 2];

	diag_log "Paradigm: Player initialisation complete";
};