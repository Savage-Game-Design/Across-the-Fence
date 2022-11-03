/*
    File: fn_db_init.sqf
    Author: Cerebral
    Date: 2022-11-03
    Last Update: 
    Public: No

    Description:
		Tries to find EXTDB3
		If found it will try to connect to the database
		Otherwise it will fallback to the profile namespace

    Parameter(s):
		N/A

    Returns: nothing

    Example(s):
		call vgm_s_fnc_db_init;
		
*/

// Check if EXTDB3 is loaded
if (isClass (configFile >> "CfgFunctions" >> "extDB3")) then {
	// EXTDB3 is loaded
	// Try to connect to the database
	try
	{
		private _result = "";
		vgm_s_db_sql_id = round(random 9999);
		uiNamespace setVariable ["vgm_s_db_sql_id", vgm_s_db_sql_id];

		// Add database to extDB3
		_result = "extDB3" callExtension format ["9:ADD_DATABASE:%1", vgm_s_db_database_name];
		if (_result != "[1]") then {
			// Failed to connect to database
			throw "VGM: Failed to connect to database please ensure the database is running and exists.";
		};

		// Add database protocol to extDB3
		_result = "extDB3" callExtension format ["9:ADD_DATABASE_PROTOCOL:%2:SQL:%1:TEXT2", vgm_s_db_sql_id, vgm_s_db_database_name];
		if (_result != "[1]") then {
			// Failed to connect to database
			throw "VGM: Failed to connect to database please ensure the database is running and exists.";
		};

		"extDB3" callExtension "9:LOCK";
    	diag_log "VGM: Successfully connected to the database!";
		uiNamespace setVariable ["vgm_s_db_type", "extDB3"];
	} 
	catch 
	{
		// Connection failed
		// Fallback to profile namespace
		uiNamespace setVariable ["vgm_s_db_type", "profile"];
		diag_log _exception;
	};
} else {
	// EXTDB3 is not loaded
	// Fallback to profile namespace
	uiNamespace setVariable ["vgm_s_db_type", "profile"];
};