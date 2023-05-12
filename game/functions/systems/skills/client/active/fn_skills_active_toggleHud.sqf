/*
    File: fn_skills_active_toggleHud.sqf
    Author: Savage Game Design
    Date: 2023-05-12
    Last Update: 2023-05-12
    Public: Yes

    Description:
        Toggle active skills HUD.

    Parameter(s):
        N/A

    Returns:
        Hud Layer ID [NUMBER]

    Example(s):
        [true] call vgm_c_fnc_skill_active_toggleHud
 */

params [
    ["_enable", true, [true]]
];

if (_enable) exitWith {
    "vgm_skills_active_hud" cutRsc ["VGM_RscAbilityCooldown", "PLAIN", 0, false];
};

"vgm_skills_active_hud" cutFadeOut 1;
