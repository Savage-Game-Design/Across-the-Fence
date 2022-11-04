/*
    File: fn_handle_welcome_screen.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update: 
    Public: /shrug

    Description:
        used to check if welcome screen needs to show, and then show it

    Parameter(s):
        N/A

    Returns: nothing

    Example(s):
        call vgm_c_fnc_handle_welcome_screen;
        
*/

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

    if (_welcomeScreenEnabled == 1) exitWith {
        createDialog "para_WelcomeScreen";
    };
};