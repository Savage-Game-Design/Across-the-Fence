/*
    File: fn_skills_apply_hoofIt.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Disables stamina for 30 seconds.

    Parameter(s):

    Returns:
        [BOOL] - Skill activated successfully.

    Example(s):
        call vgm_c_fnc_skills_apply_hoofIt;
 */

player enableStamina false;
systemChat "You feel a sudden burst of energy!";

[player] spawn {
    params ["_player"];

    sleep 30;
    systemChat "You feel tired again.";
    _player enableStamina true;
};

