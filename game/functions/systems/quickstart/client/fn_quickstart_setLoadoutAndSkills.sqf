/*
    File: fn_quickstart_setLoadoutAndSkills.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Instantly sets the player's loadout and skills to the given parameters.

    Parameter(s):
        _loadout - Loadout to set [ARRAY]
        _skills - Skill paths to set [ARRAY]

    Returns:
        Nothing

    Example(s):
        [

        ] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
 */

if !(isNil "vgm_c_quickstart_inProgressScriptHandle") then {
    terminate vgm_c_quickstart_inProgressScriptHandle;
};

if !(isNil "vgm_c_quickstart_respecHandlerId") then {
    [vgm_c_quickstart_respecHandlerId] call para_g_fnc_event_unsubscribe;
};

vgm_c_quickstart_inProgressScriptHandle = _this spawn {
    params ["_loadout", "_skillPaths"];

    vgm_c_quickstart_respecPending = true;

    vgm_c_quickstart_respecHandlerId = ["vgm_skills_respecLocal", {
        vgm_c_quickstart_respecPending = false;
    }] call para_g_fnc_event_subscribeLocal;

    [] call vgm_c_fnc_skills_requestSkillRespec;

    waitUntil { vgm_c_quickstart_respecPending isEqualTo false };

    [vgm_c_quickstart_respecHandlerId] call para_g_fnc_event_unsubscribe;
    vgm_c_quickstart_respecHandlerId = nil;

    [player, 23] remoteExec ["vgm_s_fnc_leveling_skipToLevel", 2];

    player setUnitLoadout _loadout;

    {
        [player, _x] remoteExecCall ["vgm_s_fnc_skills_teachSkill", 2];
    } forEach _skillPaths;

    [player] remoteExecCall ["vgm_s_fnc_skills_handle_recalculateSkillPoints", 2];
};
