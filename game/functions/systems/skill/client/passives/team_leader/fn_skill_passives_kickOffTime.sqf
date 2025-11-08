/*
    File: fn_skill_passives_kickOffTime.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-11-08
    Public: No

    Description:
        Adds or removes the "Rest overnight vote" action

    Parameter(s):
        _enabled - True if the skill should be enabled [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_kickOffTime;
 */

params ["_enable"];

private _isEnabled = missionNamespace getVariable ["vgm_c_skill_passives_kickOffTime_enabled", false];

if (_enable && !_isEnabled) exitWith {
    vgm_c_skill_passives_kickOffTime_enabled = true;

    true call vgm_c_fnc_skill_passives_kickOffTime_enableAction;

    vgm_c_skill_passives_kickOffTime_missionDeployLocalId = ["vgm_mission_deploy_local", {
        false call vgm_c_fnc_skill_passives_kickOffTime_enableAction;
    }] call para_g_fnc_event_subscribeLocal;

    vgm_c_skill_passives_kickOffTime_missionEndLocalId = ["vgm_mission_end_local", {
        true call vgm_c_fnc_skill_passives_kickOffTime_enableAction;
    }] call para_g_fnc_event_subscribeLocal;

    vgm_c_skill_passives_kickOffTime_respawnHandlerId = player addEventHandler ["Respawn", {
        true call vgm_c_fnc_skill_passives_kickOffTime_enableAction;
    }];
};

if (!_enable) exitWith {
    false call vgm_c_fnc_skill_passives_kickOffTime_enableAction;
    [vgm_c_skill_passives_kickOffTime_missionDeployLocalId] call para_g_fnc_event_unsubscribe;
    [vgm_c_skill_passives_kickOffTime_missionEndLocalId] call para_g_fnc_event_unsubscribe;
    player removeEventHandler ["Respawn", vgm_c_skill_passives_kickOffTime_respawnHandlerId];
};
