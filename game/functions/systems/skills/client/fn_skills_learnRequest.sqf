/*
    File: fn_skills_learnRequest.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-01-22
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

[player, _skill get "path"] remoteExecCall ["vgm_s_fnc_skills_handleLearnRequest", 2];

["Waiting for server...", "Please wait", false, false, _display] spawn BIS_fnc_guiMessage;

private _result = nil;
waitUntil {
    !isNil {
        _result = player getVariable "vgm_c_skills_learnRequestResult";
        _result // return
    } // return
};

// close the popup
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];
player setVariable ["vgm_c_skills_learnRequestResult", nil];

if (_result && {[_skill, true] call vgm_c_fnc_skills_learn}) then {
    hint format ["Learnt skill - %1", _skill get "displayName"];
} else {
    hint format ["Failed to learn skill - %1", _skill get "displayName"];
};
