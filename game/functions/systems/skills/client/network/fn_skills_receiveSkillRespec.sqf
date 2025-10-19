/*
    File: fn_skills_receiveSkillLearn.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2024-12-05
    Public: No

    Description:
        Handle receiving skill respec response from the server.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_skills_receiveSkillRespec", _player];
 */

#define EMPTY_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

["DEBUG", "Received skills respec"] call vgm_g_fnc_log;

// close the popup
// TODO keep the popup display in variable and close it via it
private _result = true;
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];

player setUnitLoadout EMPTY_LOADOUT;

["vgm_skills_respecLocal"] call para_g_fnc_event_triggerLocal;

[
    "Skills reset. Re-assign your refunded skill points in the skills menu.",
    "",
    true,
    false
] spawn BIS_fnc_guiMessage;