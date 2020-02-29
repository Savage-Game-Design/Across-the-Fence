// init vars
vn_mf_buildindex = 0;
vn_mf_buildDirection = 0;

0 spawn {
	diag_log "VN: Client Init started";

	waitUntil {!(call BIS_fnc_isLoading)};

	// start loading screen
	startLoadingScreen ["Welcome to Mike Force!", "MikeForce_loadingScreen"];

	[selectRandom (getArray(missionConfigFile >> "gamemode" >> "loadingScreens" >> "images")),5002] call vn_mf_fnc_update_loading_screen;

    	player disableConversation true;

	waitUntil {getClientStateNumber > 8};

	// wait for player to load into game
	waitUntil {!isNull findDisplay 46};

	// make sure server is finished with setup
	waitUntil {missionNamespace getVariable ["vn_mf_server_ready",false]};

	// do player init
	[player] remoteExecCall ["vn_mf_fnc_init_player",2];

	progressLoadingScreen 0.1;

	diag_log "VN: Client Init finished";
};
