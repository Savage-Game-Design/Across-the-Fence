/*
    File: fn_skills_requestSkillLearn.sqf
    Author: Savage Game Deisgn
    Date: 2023-02-26
    Last Update: 2024-07-04
    Public: No

    Description:
        Request skill respec from the server.

    Parameter(s):
        _displayParent - Display to show waiting message on [DISPLAY]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skills_requestSkillRespec
 */

[player] spawn {
    params ["_player"];

    private _result = [
        "Are you sure you want to reset all your skills? (Spent skill points will be refunded).",
        "",
        true,
        true
    ] call BIS_fnc_guiMessage;

    if (_result) then {
        [_player] remoteExecCall ["vgm_s_fnc_skills_handle_skillRespecRequest", 2];
    };
};
