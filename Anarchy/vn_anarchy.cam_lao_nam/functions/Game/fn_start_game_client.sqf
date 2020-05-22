// init vars
vn_an_buildindex = 0;
vn_an_buildDirection = 0;

0 spawn {
	diag_log "VN: Client Init started";

	waitUntil {uiSleep 0.1; !(call BIS_fnc_isLoading)};

	// start loading screen
	startLoadingScreen ["Welcome to Mike Force!", "MikeForce_loadingScreen"];

	[selectRandom (getArray(missionConfigFile >> "gamemode" >> "loadingScreens" >> "images")),5002] call vn_an_fnc_update_loading_screen;

    	player disableConversation true;

	waitUntil {uiSleep 0.1; getClientStateNumber > 8};

	// wait for player to load into game
	waitUntil {uiSleep 0.1; !isNull findDisplay 46};

	vn_an_loading_started = diag_tickTime;

	vn_an_loading_failed = false;

	// make sure server is finished with setup
	waitUntil
	{
		uiSleep 0.1;
		if (diag_tickTime - vn_an_loading_started >= 90) exitWith {vn_an_loading_failed = true; true};
		missionNamespace getVariable ["vn_an_server_ready",false]
	};

	if (vn_an_loading_failed) then {
		endLoadingScreen;
		// reject player
		["TimedOut", false, 2, false] call BIS_fnc_endMission;

		diag_log "VN: Client login timed out";
	}
	else
	{
	// do player init
		[player] remoteExecCall ["vn_an_fnc_init_player",2];

	progressLoadingScreen 0.1;

	diag_log "VN: Client Init finished";
	};


};
