/*
    File: fn_handle_welcome_screen.sqf
    Author: Gus Schultz
    Date: 2022-09-18
    Last Update: 2022-12-03
    Public: No

    Description:
        Used to check if welcome screen needs to show, and then show it

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_handle_welcome_screen;

*/

[] spawn {
    uiSleep 2;
    private _lastVersion = (["GET", "last_version", ""] call para_s_fnc_profile_db) select 1;
    //Open welcome screen for new players
    private _welcomeScreenEnabled = ["para_enableWelcomeScreen"] call para_c_fnc_optionsMenu_getValue;
    private _versionHasChanged = _lastVersion == "" || _lastVersion != vgm_version;

    if (_versionHasChanged) exitWith {
        createDialog "para_ChangelogScreen";
        ["SET", "last_version", vgm_version] call para_s_fnc_profile_db;
    };

    if (_welcomeScreenEnabled) exitWith {
        createDialog "para_WelcomeScreen";
    };
};
