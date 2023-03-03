/*
    File: fn_skills_receiveSkillLearn.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2023-02-26
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

["DEBUG", "VGM: Received skills respec"] call para_g_fnc_log;

// close the popup
// TODO keep the popup display in variable and close it via it
private _result = true;
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];

hint "Skill respec done";
