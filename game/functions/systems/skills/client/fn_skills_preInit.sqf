/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2025-11-29
    Public: No

    Description:
        Client preInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

vgm_c_skills_applyOnRespawn = createHashMap;
vgm_c_skills_applyOnRespawnGroup = createHashMap;

vgm_c_skills_appliedSkillsPaths = [];
vgm_c_skills_appliedGroupSkills = createHashMap;

["skills"] call vgm_c_fnc_persistence_registerSchema;

["vgm_skills_learnt", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeApply");
    if (_skill get "applyOnRespawn") then {
        vgm_c_skills_applyOnRespawn set [_path, _skill]
    };

    if (_skill get "isGroupSkill") then {
        // Save to a list of active group skills, that other players can use to apply the skill effects when they join the group.
        private _learntGroupSkills = player getVariable ["vgm_g_skills_learntGroupSkills", []];
        _learntGroupSkills pushBackUnique _path;
        player setVariable ["vgm_g_skills_learntGroupSkills", _learntGroupSkills, true];

        private _targets = (call vgm_c_fnc_missions_getTeamMembers) select { isPlayer _x };

        // Trigger the effects on current group members.
        ["vgm_skills_codeApplyGroup", [_path, getPlayerID player, player], _targets] call para_g_fnc_event_triggerTargets;
    };
}] call para_g_fnc_event_subscribeLocal;

// When a player learns a skill with codeApplyGroup, this is called on each player in the group's machine to set up the skill.
["vgm_skills_codeApplyGroup", {
    _this#0 params ["_path", "_owningPlayerId", "_owningPlayer"];

    private _skill = [_path] call vgm_g_fnc_skills_getByPath;
    [_skill, _owningPlayerId] call vgm_c_fnc_skills_applyGroupSkill;
}] call para_g_fnc_event_subscribe;

["vgm_mission_attached", {
    _this#0 params ["_playerId", "_missionId", "_playerUnit"];

    private _myMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_myMission") exitWith {};

    // Local player has joined a new mission - apply group skills from all existing mission members.
    if (_playerId isEqualTo getPlayerID player) exitWith {
        {
            private _otherUnit = _x;
            {
                [[_x] call vgm_g_fnc_skills_getByPath, getPlayerID _otherUnit] call vgm_c_fnc_skills_applyGroupSkill;
            } forEach (_otherUnit getVariable ["vgm_g_skills_learntGroupSkills", []]);
        } forEach (units (_myMission get "group") select {_x isNotEqualTo player});
    };

    // Another player has joined the local player's mission. Apply group skills just from them.
    if (_missionId isEqualTo (_myMission get "id")) exitWith {
        {
            [[_x] call vgm_g_fnc_skills_getByPath, _playerId] call vgm_c_fnc_skills_applyGroupSkill;
        } forEach (_playerUnit getVariable ["vgm_g_skills_learntGroupSkills", []]);
    };
}] call para_g_fnc_event_subscribeServer;

["vgm_skills_forgotten", {
    _this#0 params ["_path", "_skill"];

    player call (_skill get "codeUnapply");
    vgm_c_skills_applyOnRespawn deleteAt _path;

    if (_skill get "isGroupSkill") then {
        // Removes the skill from the player's list of known group skills
        private _learntGroupSkills = player getVariable ["vgm_g_skills_learntGroupSkills", []];
        _learntGroupSkills deleteAt (_learntGroupSkills find _path);
        player setVariable ["vgm_g_skills_learntGroupSkills", _learntGroupSkills, true];

        private _mission = [] call vgm_c_fnc_missions_getCurrentMission;
        private _targets = if (isNil "_mission") then { [player] } else { units (_mission get "group") select { isPlayer _x } };

        // Triggers the skill effects to be removed from any players currently in the group.
        ["vgm_skills_codeUnapplyGroup", [_path, getPlayerID player, player], _targets] call para_g_fnc_event_triggerTargets;
    };
}] call para_g_fnc_event_subscribeLocal;

["vgm_skills_codeUnapplyGroup", {
    _this#0 params ["_path", "_owningPlayerId", "_owningPlayer"];

    private _skill = [_path] call vgm_g_fnc_skills_getByPath;
    [_skill, _owningPlayerId] call vgm_c_fnc_skills_unapplyGroupSkill;

}] call para_g_fnc_event_subscribe;

["vgm_mission_playerRemoved", {
    _this#0 params ["_playerId", "_missionId", "_playerUnit"];

    private _localPlayerId = getPlayerID player;

    // Local player left group - unapply group skills from everyone except the local player.
    if (_playerId isEqualTo _localPlayerId) exitWith {
        private _playerIds = keys vgm_c_skills_appliedGroupSkills select {_x isNotEqualTo _localPlayerId};
        {
            [_x] call vgm_c_fnc_skills_unapplyPlayersGroupSkills;
        } forEach _playerIds;
    };

    // Another player left group - unapply group skills from only them.
    private _myMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_myMission") exitWith {};

    if (_missionId isEqualTo (_myMission get "id")) exitWith {
        [_playerId] call vgm_c_fnc_skills_unapplyPlayersGroupSkills;
    };
}] call para_g_fnc_event_subscribeServer;

["skillCooldown", {
    params ["_unit", "_value"];
    _unit setVariable ["vgm_c_skills_cooldownCoef", _value max 0.5 min 1];
}] call vgm_c_fnc_coefficient_create;

[] call vgm_c_fnc_skills_active_init;

["skills", {
    !isNil {player getVariable "vgm_g_skillsData"}
}] call vgm_c_fnc_loading_addHandler;
