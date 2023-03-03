/*
    File: fn_skills_requestSkillLearn.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        Request skill learn from the server.

    Parameter(s):
        _skill - The skill about to be learnt [HASHMAP]
        _display - Display to show the waiting message [DISPLAY]

    Returns:
        Nothing

    Example(s):
        [_skill, _display] call vgm_c_fnc_skills_requestSkillLearn
 */

params ["_skill", ["_display", displayNull]];

["Waiting for server...", "Please wait", false, false, _display] spawn BIS_fnc_guiMessage;

[player, _skill get "path"] remoteExecCall ["vgm_s_fnc_skills_handle_skillLearnRequest", 2];
