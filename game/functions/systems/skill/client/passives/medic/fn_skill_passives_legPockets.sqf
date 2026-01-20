/*
    File: fn_skill_passives_legPockets.sqf
    Author: Savage Game Design
    Date: 2025-12-24
    Last Update: 2026-01-20
    Public: No

    Description:
        Adds logic for Medic Tier 1 Leg Pockets skill.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_known"];

if (!_known) exitWith {
    private _eh = player getVariable "vgm_c_skill_passives_legPocketsEH";
    if (isNil "_eh") exitWith {};
    [_eh] call para_g_fnc_event_unsubscribe;
};

private _eh = ["vgm_medical_itemConsumed", {
    params ["_args"];
    _args params ["_unit", "_consumedItem"];
    if (_consumedItem != "vn_helper_item_firstaidkit" || _unit != player) exitWith {};

    private _usedInMission = _unit getVariable ["vgm_c_skill_passives_legPocketsMission", createHashMap];
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (_usedInMission isEqualTo _currentMission) exitWith {};

    if (_consumedItem in items _unit) exitWith {};

    _unit setVariable ["vgm_c_skill_passives_legPocketsMission", _currentMission];

    ["Medic/Leg pockets skill triggered"] call vgm_g_fnc_logInfo;
    hint "STR_VGM_SKILLS_SKILL_LEG_POCKETS_ACTIVATED";

    _unit addItem _consumedItem;
    _unit addItem _consumedItem;

}] call para_g_fnc_event_subscribe;

player setVariable [ "vgm_c_skill_passives_legPocketsEH", _eh];
