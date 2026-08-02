/*
    File: fn_radiocheckin_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Client-side initialization for the radio check-in system.
        After deploying, shows a one-time reminder hint. The check-in action
        is registered as an "always" wheel menu entry (key 6), visible only
        to the group leader while on mission.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_radiocheckin_postInit;
*/

if (!hasInterface) exitWith {};

// On deploy: show one-time reminder hint
["vgm_mission_deploy_local", {
    hint localize "STR_VGM_RADIOCHECKIN_HINT_REMINDER";
}] call para_g_fnc_event_subscribeLocal;

// Register wheel menu action (key 6) - always entry with runtime condition
para_c_wheel_menu_actions_always pushBack (createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"],
    ["function", "vgm_c_fnc_radiocheckin_doCheckin"],
    ["text", localize "STR_VGM_RADIOCHECKIN_ACTION"],
    ["spawnFunction", false]
]);
