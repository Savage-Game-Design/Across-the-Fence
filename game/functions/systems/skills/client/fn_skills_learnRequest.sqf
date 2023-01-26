/*
    File: fn_skills_learnRequest.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-01-26
    Public: No

    Description:
        Client side function to request skill learning.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_skill, true] call vgm_c_fnc_skills_learn
 */

// TODO: refactor this fnc to be event based?
params ["_skill", "_display"];

["Waiting for server...", "Please wait", false, false, _display] spawn BIS_fnc_guiMessage;

private _handlerId = [];
_handlerId pushBack ([["vgm_skills_learnResponse", player], [[_skill, _handlerId], {
    params ["_result", "_args"];
    _args params ["_skill", "_handlerId"];

    _handlerId call para_g_fnc_event_unsubscribe;

    // close the popup
    uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];
    player setVariable ["vgm_c_skills_learnRequestResult", nil];

    if (_result && {[_skill, true] call vgm_c_fnc_skills_learn}) then {
        hint format ["Learnt skill - %1", _skill get "displayName"];
    } else {
        hint format ["Failed to learn skill - %1", _skill get "displayName"];
    };
}]] call para_g_fnc_event_subscribeServer);

[player, _skill get "path"] remoteExecCall ["vgm_s_fnc_skills_handleLearnRequest", 2];
