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

// DB Macros
#define CONST(var1,var2) var1 = compileFinal (if (var2 isEqualType "") then {var2} else {str(var2)})
#define CONSTVAR(var) var = compileFinal (if (var isEqualType "") then {var} else {str(var)})
#define FETCH_CONST(var) (call var)
#define EXTDB "extDB3" callExtension

// Check if EXTDB3 is loaded
if (isClass (configFile >> "CfgFunctions" >> "extDB3")) exitWith {
    // EXTDB3 is loaded

    if (!(isNil {uiNamespace getVariable "vgm_s_db_sql_id"})) exitWith {
        // EXTDB3 is already connected to a database
        // Do nothing

        vgm_s_db_sql_id = uiNamespace getVariable "vgm_s_db_sql_id";
        CONSTVAR(vgm_s_db_sql_id);
        uiNamespace setVariable ["vgm_s_db_type", "extDB3"];
        diag_log "VGM: Already connected to the database.";
    };

    // Try to connect to the database
    try
    {
        private _result = "";
        vgm_s_db_sql_id = round(random 9999);
        CONSTVAR(vgm_s_db_sql_id);
        uiNamespace setVariable ["vgm_s_db_sql_id", vgm_s_db_sql_id];

        // Add database to extDB3
        _result = EXTDB format ["9:ADD_DATABASE:%1", "anarchy"];

        if (!(_result isEqualTo "[1]")) then {
            // Failed to connect to database
            throw "VGM: Failed to connect to database please ensure the database is running and exists. 1";
        };

        // Add database protocol to extDB3
        _result = EXTDB format ["9:ADD_DATABASE_PROTOCOL:%2:SQL:%1:TEXT2", FETCH_CONST(vgm_s_db_sql_id), "vgm"];

        if (!(_result isEqualTo "[1]")) then {
            // Failed to connect to database
            throw "VGM: Failed to connect to database please ensure the database is running and exists. 2";
        };

        EXTDB "9:LOCK";
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
};

// EXTDB3 is not loaded
// Fallback to profile namespace
uiNamespace setVariable ["vgm_s_db_type", "profile"];