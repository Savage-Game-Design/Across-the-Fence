/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-06-02
    Public: No

    Description:
        Server preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

["vgm_leveling_levelGained", {
    (_this#0) params ["_player", "_levelData"];

    private _skillPoints = _levelData get "skillPoints";
    [_player, _skillPoints] call vgm_s_fnc_skills_addSkillPoint;
}] call para_g_fnc_event_subscribeLocal;
