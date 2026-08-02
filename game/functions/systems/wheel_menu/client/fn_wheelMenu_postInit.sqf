/*
    File: fn_wheelMenu_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Registers context-sensitive wheel menu actions at postInit.
        - Extraction actions (request, timer, evac now) as "ALWAYS" entries
          with complex runtime conditions
        - Skill Presets as dynamic object actions on hub objects

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_wheelMenu_postInit;
*/

if (!hasInterface) exitWith {};

// --- Extraction Actions (ALWAYS visible, conditions checked live) ---

// Request Extraction
para_c_wheel_menu_actions_always pushBack (createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
        && {(group player) getVariable ["vgm_missions_extraction_canRequest", true]}
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa"],
    ["function", "vgm_c_fnc_wheelMenu_requestExtract"],
    ["text", localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_ACTION"],
    ["spawnFunction", true]
]);

// Set Extraction Timer (30s countdown)
para_c_wheel_menu_actions_always pushBack (createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
        && {
            private _helicopter = (group player) getVariable ["vgm_missions_extraction_helicopter", objNull];
            !isNull _helicopter
            && {_helicopter getVariable ["vgm_missions_extractionLanded", false]}
            && {!(_helicopter getVariable ["vgm_missions_extraction_evacNow", false])}
            && {(_helicopter getVariable ["vgm_missions_extraction_evacAt", -1]) isEqualTo -1}
        }
        && {!((group player) getVariable ["vgm_missions_extraction_canRequest", true])}
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa"],
    ["function", "vgm_c_fnc_wheelMenu_evacTimer"],
    ["text", localize "STR_VGM_MISSIONS_EXTRACTION_EVACTIMER_ACTION"],
    ["spawnFunction", true]
]);

// Evac Now (immediate departure)
para_c_wheel_menu_actions_always pushBack (createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
        && {
            private _helicopter = (group player) getVariable ["vgm_missions_extraction_helicopter", objNull];
            !isNull _helicopter
            && {_helicopter getVariable ["vgm_missions_extractionLanded", false] || _helicopter getVariable ["vgm_missions_stabo_hookupReady", false]}
            && {!(_helicopter getVariable ["vgm_missions_extraction_evacNow", false])}
        }
        && {!((group player) getVariable ["vgm_missions_extraction_canRequest", true])}
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa"],
    ["function", "vgm_c_fnc_wheelMenu_evacNow"],
    ["text", localize "STR_VGM_MISSIONS_EXTRACTION_EVACNOW_ACTION"],
    ["spawnFunction", true]
]);

// --- Skill Presets (object-specific actions on hub objects) ---

private _skillObjects = [
    missionNamespace getVariable ["vgm_skills_1", objNull],
    missionNamespace getVariable ["vgm_skills_2", objNull]
];

{
    if (isNull _x) then { continue };

    [
        _x,
        createHashMapFromArray [
            ["condition", {!vgm_mission_onMission}],
            ["iconPath", "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa"],
            ["function", "vgm_c_fnc_skillPresets_openMenu"],
            ["text", localize "STR_VGM_SKILL_PRESETS_ACTION"]
        ]
    ] call para_c_fnc_wheel_menu_add_obj_action;
} forEach _skillObjects;
