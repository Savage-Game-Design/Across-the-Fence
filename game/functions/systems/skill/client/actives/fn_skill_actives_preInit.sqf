/*
    File: fn_skill_actives_preInit.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2023-10-14
    Public: No

    Description:
        Client preInit function for skill actives implementations.
 */

["vgm_skill_support_getToTheLz", {

    ["Support/To The LZ skill activated"] call vgm_g_fnc_logInfo;

    [player, "animSpeed", "skill_support_getToTheLz", 0.1] call vgm_c_fnc_coefficient_set;
    [player, "hitShrug", "skill_support_getToTheLz", 0.4] call vgm_c_fnc_coefficient_set;
    [player, "staminaDrain", "skill_support_getToTheLz", -0.3] call vgm_c_fnc_coefficient_set;

    ["skill_support_getToTheLz", {
        ["Support/Get To The LZ skill exhausted"] call vgm_g_fnc_logInfo;

        [player, "animSpeed", "skill_support_getToTheLz"] call vgm_c_fnc_coefficient_remove;
        [player, "hitShrug", "skill_support_getToTheLz"] call vgm_c_fnc_coefficient_remove;
        [player, "staminaDrain", "skill_support_getToTheLz"] call vgm_c_fnc_coefficient_remove;
    }, 30, "seconds"] call BIS_fnc_runLater;

}] call para_g_fnc_event_subscribe;
