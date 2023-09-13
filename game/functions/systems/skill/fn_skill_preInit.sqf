/*
    File: fn_skill_preInit.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-14
    Public: No

    Description:
        Client preInit function for skill implementations.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

["mission started", {
    params ["_missionId"];
    private _mission = [] call vgm_c_fnc_missions_getMissions get _missionId;

    {
        if (_x getVariable ["vgm_g_skill_actives_bornLeader", false]) then {
            format ["Rifleman/Born Leader player in mission: %1", getPlayerID _x] call vgm_g_fnc_logDebug;

            [player, "skillCooldown", format ["skill_born_leader_%1", getPlayerId _x], -0.2] call vgm_c_fnc_coefficient_set;
        };
    } forEach (_mission get "players");

}] call para_g_fnc_event_subscribeServer;
