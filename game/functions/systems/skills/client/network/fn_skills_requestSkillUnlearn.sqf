/*
    File: fn_skills_requestSkillUnlearn.sqf
    Author: Atlas
    Date: 2026-03-04
    Public: No

    Description:
        Request skill unlearn from the server.

    Parameter(s):
        _skill   - The skill to unlearn [HASHMAP]
        _display - Display to show the waiting message [DISPLAY]

    Returns:
        Nothing

    Example(s):
        [_skill, _display] call vgm_c_fnc_skills_requestSkillUnlearn
*/

params ["_skill", ["_display", displayNull]];

["Waiting for server...", "Please wait", false, false, _display] spawn BIS_fnc_guiMessage;

[player, _skill get "path"] remoteExecCall ["vgm_s_fnc_skills_handle_skillUnlearnRequest", 2];
