/*
    File: fn_skill_actives_slamTime2.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — SLAM Time 2. Rearms the player's M20 Super Bazooka
        with one HEAT magazine. Requires the weapon to be equipped.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_slamTime2
 */

params ["", "_skill"];

["Tail/SLAM Time 2 skill activated"] call vgm_g_fnc_logInfo;

if !("vn_m20a1b1_01" in weapons player) exitWith {
    ["Tail/SLAM Time 2: No recoilless rifle equipped"] call vgm_g_fnc_logWarning;
};

player addMagazine "vn_m20a1b1_heat_mag";
hint localize "STR_VGM_SKILLS_SKILL_SLAM_TIME_2_ACTIVATED";
