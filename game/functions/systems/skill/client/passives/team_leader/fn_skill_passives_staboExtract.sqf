/*
    File: fn_skill_passives_staboExtract.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-06
    Public: No

    Description:
        Team Leader tier 4 passive skill. When learned, adds a "Request STABO
        Extraction" wheel menu action (key 6). Instead of a normal landing
        extraction, the helicopter hovers above the canopy and drops a STABO
        rope for the team to hook up to.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_staboExtract
 */

params ["_known"];

if (!hasInterface) exitWith {};

if (!_known) exitWith {
    private _idx = player getVariable ["vgm_c_skill_staboExtract_wheelIdx", -1];
    if (_idx >= 0) then {
        para_c_wheel_menu_actions_always deleteAt _idx;
        player setVariable ["vgm_c_skill_staboExtract_wheelIdx", -1];
    };
};

private _action = createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
        && {(group player) getVariable ["vgm_missions_extraction_canRequest", true]}
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"],
    ["function", "vgm_c_fnc_skill_passives_staboExtract_request"],
    ["text", localize "STR_VGM_SKILLS_SKILL_STABO_EXTRACT_ACTION"],
    ["spawnFunction", true]
];

private _idx = count para_c_wheel_menu_actions_always;
para_c_wheel_menu_actions_always pushBack _action;
player setVariable ["vgm_c_skill_staboExtract_wheelIdx", _idx];
