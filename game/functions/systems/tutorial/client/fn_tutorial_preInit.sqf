#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
    File: fn_tutorial_preInit.sqf
    Author:
    Date: 2024-11-16
    Last Update: 2026-04-04
    Public: No

    Description:
        PreInit for the tutorial system

*/

if (!hasInterface) exitWith {};
[] call para_c_fnc_ui_hints_setup;

vgm_g_tutorial_disable = ["tutorial_disable", 0] call BIS_fnc_getParamValue > 0;

[
    createHashMapFromArray [
        ["name", "TutorialAcknowledgeHint"],
        ["displayName", "STR_VGM_TUTORIAL_UI_ACKNOWLEDGE_HINT"],
        ["onRelease", false],
        ["defaultKey", createHashMapFromArray [
            ["dikCode", DIK_8]
        ]]
    ]
] call para_c_fnc_keyhandler_registerAction;
["TutorialAcknowledgeHint", para_c_fnc_ui_hints_acknowledgeHintKeypress] call para_c_fnc_keyhandler_addGeneralActionHandler;

// Ideally store this on the server.
vgm_c_tutorial_seenTutorials = missionProfileNamespace getVariable ["vgm_tutorial_seenTutorials", createHashMap];

["init_player_ready", {
    ["vgm_welcome", "welcome"] call vgm_c_fnc_openFieldManual;

    private _fnc_addAlertnessTutorial = {
        params ["_unit"];
        private _ehId = _unit getVariable ["vgm_c_tutorial_alertnessFiredEh", -1];
        if (_ehId > -1) exitWith {_ehId};

        _ehId = _unit addEventHandler ["Fired", {
            ["vgm_missions", "alertness", "alertness"] call vgm_c_fnc_tutorial_trigger;
        }];

        _unit setVariable ["vgm_c_tutorial_alertnessFiredEh", _ehId];
    };
    [player] call _fnc_addAlertnessTutorial;
    player addEventHandler ["Respawn", {(this # 0) call _fnc_addAlertnessTutorial}];
}] call para_g_fnc_event_subscribeLocal;

["vgm_field_manual_closed", {
    ["vgm_welcome", "getting_started", "getting_started"] call vgm_c_fnc_tutorial_trigger;
}] call para_g_fnc_event_subscribeLocal;

// This also should trigger when mission boards are looked at.
[true, "arsenalClosed", {
    ["vgm", "missions", "after_arsenal"] call vgm_c_fnc_tutorial_trigger;
}] call BIS_fnc_addScriptedEventHandler;

// When the local player creates a mission.
["vgm_mission_created", {
    ["vgm", "missions", "mission_created"] call vgm_c_fnc_tutorial_trigger;
}] call para_g_fnc_event_subscribeServer;

// When the local player joins a mission.
["vgm_mission_joined", {
    ["vgm", "missions", "mission_joined"] call vgm_c_fnc_tutorial_trigger;
}] call para_g_fnc_event_subscribeServer;

["vgm_listen_mode_enabled", {
    ["vgm_missions", "stop_and_focus", "stop_and_focus"] call vgm_c_fnc_tutorial_trigger;
}] call para_g_fnc_event_subscribeLocal;


["vgm_mission_deploy_local", {
    ["vgm_missions", "stealth", "stealth"] call vgm_c_fnc_tutorial_trigger;
    [] spawn {
        sleep 60;
        ["vgm", "missions", "extraction"] call vgm_c_fnc_tutorial_trigger;
    };
}] call para_g_fnc_event_subscribeLocal;

["vgm_leveling_levelGained", {
    params ["_eventArgs"];
    _eventArgs params ["_player", "_currentLevelData"];
    if (_player isEqualTo player && _currentLevelData get "skillPoints" > 0) then {
        ["vgm", "skills", "levelling_up"] call vgm_c_fnc_tutorial_trigger;
    };
}] call para_g_fnc_event_subscribeServer;

["vgm_skills_learnt", {
    params ["_eventArgs"];
    _eventArgs params ["_skillPath", "_skill"];
    if (_skill get "isActive") then {
        ["vgm", "skills", "equipping_skills"] call vgm_c_fnc_tutorial_trigger;
    };
}] call para_g_fnc_event_subscribeLocal;

["vgm_sites_hints_glint", {
    ["vgm_missions", "hints", "glint_seen"] call vgm_c_fnc_tutorial_trigger;
}] call para_g_fnc_event_subscribeLocal;

["vgm_medical_unconscious", {
    ["vgm_missions", "desperate_escape", "desperate_escape"] call vgm_c_fnc_tutorial_trigger
}] call para_g_fnc_event_subscribeLocal;

addMissionEventHandler ["Map", {
    params ["_mapIsOpened"];
    if (_mapIsOpened && !isNil {[] call vgm_c_fnc_missions_getCurrentMission}) then {
        ["vgm_missions", "scouting", "scouting"] call vgm_c_fnc_tutorial_trigger;
    };
}];

