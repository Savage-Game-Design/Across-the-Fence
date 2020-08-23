

// Set up the required Eventhandler for the backend- and player-handling:
diag_log str ["ASC - Setting up Eventhandler..."];
// set the Callback Eventhandler
addMissionEventHandler ["ExtensionCallback", AN_S_fnc_ext_CE_callback_server];
// add user to "await"-list in the backend (spawned!)
addMissionEventHandler ["PlayerConnected", {_this spawn AN_S_fnc_player_connected}];
// remove player on Disconnect from backend
addMissionEventHandler ["PlayerDisconnected", AN_S_fnc_player_disconnected];
// Done
diag_log str ["AN_ASC - Setting up Eventhandler... done"];

/*
//////////////////////////////////////////////////////////////////////////////////
	Try to establish a connection to the backend, using the ASC Extension:

	Description:
	Starting of the ArmaServerCompanion (ASC) backend and auto-connect to it, with one of the following methods:
	ASC will try to connect to the given IP:Port first, before it will try to start the backend localy.
	If this first attemp fails, it will start up the backend, using the parameters given by the config.cfg
	
	
	:: Method #1:
	- Notes:
		Pass the Path to the config.cfg directly
	- Example sqf:
		"asc_extension" callExtension ["init_server",["D:\ArmaServerCompanion\config.cfg"]];
	
	
	:: Method #2:
	- Notes:
		If no params are given, it uses the "asc_files" folder in your A3-Server Root Directory
			Example path:							"C:\A3-Server\arma3server_x64.exe"
			So the path to "asc_files" would be:	"C:\A3-Server\asc_files\config.cfg"
	- Example sqf:
		"asc_extension" callExtension ["init_server",[]];
	
	
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!! Remember to change the PASSWORD in the config.cfg !!
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////
*/

diag_log str ["AN_ASC - Setting up Server connection..."];

// Send the stuff
"asc_extension" callExtension ["init_server",[]];

diag_log str ["AN_ASC - Setting up Server connection... request send..."];

/////////////////////////////////////////

// Set the seed and the crates array

// Silly Arma...
vn_an_seed_tmp = compileFinal "9283";

// Seed is now locked/finalized and a number again
vn_an_seed = call vn_an_seed_tmp;

// make the seed public
missionNamespace setVariable ["vn_an_seed", vn_an_seed, true];