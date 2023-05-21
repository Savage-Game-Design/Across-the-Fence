/*
    File: fn_skills_apply_hoofIt.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Disables stamina for 30 seconds.

    Parameter(s):
        _player - The player to apply the ability to.

    Returns:
        [BOOL] - Skill activated successfully.

    Example(s):
        [_player] call vgm_s_fnc_skills_apply_hoofIt;
 */

params ["_player"];

if (isNil "_player") exitWith {false};

[[], {
    player enableStamina false;

    [player] spawn {
        params ["_player"];

        sleep 30;
        _player enableStamina true;
    };
}] remoteExec ["call", [_player]];

true
