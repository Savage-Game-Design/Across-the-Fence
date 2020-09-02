/*
	File: fn_start_game_client.sqf
	Author: Aaron Clark <vbawol>
	Date: 2020-05-23
	Last Update: 2020-07-04
	Public: No

	Description:
		Intializes the game.

	Parameter(s): none

	Returns: nothing

	Example(s): none
*/
0 spawn {
	diag_log "VN: Client Init started";

	waitUntil {uiSleep 0.1; !(call BIS_fnc_isLoading)};

	cutText ["", "BLACK IN", 1];

	// start loading screen
	startLoadingScreen ["Welcome to Anarchy!", "para_loadingScreen"];

	// [selectRandom (getArray(missionConfigFile >> "gamemode" >> "loadingScreens" >> "images")),5002] call vn_an_fnc_update_loading_screen;

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
