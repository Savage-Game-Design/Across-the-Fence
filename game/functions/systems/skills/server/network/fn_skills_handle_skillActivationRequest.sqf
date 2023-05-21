/*
    File: fn_skills_handle_skillActivationRequest.sqf
    Author: Savage Game Design
    Date: 2023-05-21
    Last Update: 2023-05-21
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        [BOOL] - Skill was successfully activated.

    Example(s):
        [player, _skillPath] remoteExecCall ["vgm_s_fnc_skills_handle_skillActivationRequest", 2];
 */

params ["_player", "_skillPath"];

private _skill = [_skillPath] call vgm_g_fnc_skills_getByPath;
if (!([_skill, _player] call vgm_g_fnc_skills_isKnown)) exitWith {false};

if ((_skill get "clientSided") == 1) exitWith {
    [[], (_skill get "codeActivate")] remoteExec ["call", [_player]];
    true
};

_player call (_skill get "codeActivate");
true
