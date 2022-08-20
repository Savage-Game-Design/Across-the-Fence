/*
	File: para_player_init_client.sqf
	Author: Savage Game Design
	Public: Yes

	Description:
		Called on the client after player_init_server has finished.
		Serverside player initialisation is done at this point.
		It is safe to access the player object in this function.
		Used for setting up UI elements, local event handlers, etc.

		Load order:
			- para_player_preload_client.sqf - Called as soon as possible on the client.
			- para_player_loaded_client.sqf - Called on client as soon as the player is ready
			- para_player_init_server.sqf - Serverside player initialisation.
			- para_player_init_client.sqf - Clientside player initialisation.
			- para_player_postinit_server.sqf - Called on server once all player initialisation is done.

	Parameter(s):
		_player - Player to initialise [OBJECT]
		_didJIP - Whether the player joined in progress [BOOLEAN]

	Returns:
		None

	Example(s):
		//description.ext
		use_paradigm_init = 1;
*/

params ["_player", "_didJIP"];

player createDiaryRecord ["Diary", [localize "STR_vn_mf_howtobuild", localize "STR_vn_mf_howtobuild_long"], taskNull, "", false];

player createDiaryRecord ["Diary", [localize "STR_vn_mf_other_keys", localize "STR_vn_mf_other_keys_long"], taskNull, "", false];

// Instantiate the main scheduler
[] call para_g_fnc_scheduler_subsystem_init;

call para_g_fnc_event_subsystem_init;

// display initial loading text
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading1"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.2;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading2"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.3;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading3"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.4;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading4"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.5;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading5"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.6;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading6"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.7;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading7"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.8;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading8"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 0.9;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading9"]] call vn_mf_fnc_update_loading_screen;

uiSleep 0.4;
progressLoadingScreen 1.0;
[parseText format["<t font='tt2020base_vn' color='#F5F2D0'>%1</t>",localize "STR_vn_mf_loading10"]] call vn_mf_fnc_update_loading_screen;

private _respawnDelay = ["respawn_delay", 20] call BIS_fnc_getParamValue;
setplayerrespawntime _respawnDelay;

// Start AI processing for local player, if we're not a LAN server (as then serverside processing will kick in)
if (!isServer) then {
	call para_g_fnc_ai_create_behaviour_execution_loop;
};

// Set up automatic view distance scaling for performance
[] call para_c_fnc_perf_enable_dynamic_view_distance;

// initialize tools controller
call para_c_fnc_tool_controller_init;

//LOADING COMPLETE
//Start tidying up ready for play.

// end loading screen
uiSleep 0.4;
endLoadingScreen;
// Fade in
cutText ["", "BLACK IN", 4];
// Bring sound back to normal
4 fadeSound 1;
// Fade out the music
8 fadeMusic 0;
// Restore the music volume in the near future.
[] spawn {sleep 8; playMusic ""; 2 fadeMusic 1};
// Re-enable simulation
if (typeOf player != "VirtualCurator_F") then {
	player enableSimulation true;
};

[] spawn
{
	while {true} do
	{
		uiSleep 0.5;
		[] call para_c_fnc_set_aperture_based_on_light_level;
	};
};

[] spawn
{
	uiSleep 2;
	private _version = getText(missionConfigFile >> "version");
	private _lastVersion = (["GET", "last_version", ""] call para_s_fnc_profile_db) select 1;
	//Open welcome screen for new players
	private _welcomeScreenEnabled = ["para_enableWelcomeScreen"] call para_c_fnc_optionsMenu_getValue;
	private _versionHasChanged = _lastVersion == "" || _lastVersion != _version;

	if (_versionHasChanged) exitWith {
		createDialog "para_ChangelogScreen";
		["SET", "last_version", _version] call para_s_fnc_profile_db;
	};

	if (_welcomeScreenEnabled) exitWith {
		createDialog "para_WelcomeScreen";
	};
};

//DEV (ToDo): Until client Scheduler is added:
[]spawn
{
	systemchat "starting infopanel handler loop";
	"para_infopanel" cutRsc ["para_infopanel", "PLAIN", -1, true];
	while{true}do
	{
		uisleep 0.5;
		[] call para_c_fnc_infopanel_handler;
	};
};
