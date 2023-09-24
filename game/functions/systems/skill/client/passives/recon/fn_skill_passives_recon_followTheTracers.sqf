/*
    File: fn_skill_passives_recon_followTheTracers.sqf
    Author: Savage Game Design
    Date: 2023-09-24
    Last Update: 2023-09-24
    Public: No

    Description:
        Adds logic for Recon Tier 3 Follow the Tracers skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_recon_followTheTracers
 */

params ["_known"];

if (!_known) exitWith {
    player setVariable ["vgm_g_skill_passives_recon_followTheTracers", false, true];

    removeMissionEventHandler ["Draw3D", vgm_c_skill_passives_recon_followTheTracersEh];
};

vgm_c_skill_passives_recon_followTheTracers_items = createHashMap;
player setVariable ["vgm_g_skill_passives_recon_followTheTracers", true, true];

vgm_c_skill_passives_recon_followTheTracersEh = addMissionEventHandler ["Draw3d", {
    {
        private _unit = _y;
        // TODO needs design
        drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASLVisual _unit, 0, 0, 0, "Target", 1, 0.05, "PuristaMedium"];
    } forEach vgm_c_skill_passives_recon_followTheTracers_items;
}];

// TODO clear EH if skill not known
["vgm_unit_suppressStart", {
    params ["_unit"];
    vgm_c_skill_passives_recon_followTheTracers_items set [netId _unit, _unit];
}] call para_g_fnc_event_subscribeServer;

// TODO clear EH if skill not known
["vgm_unit_suppressEnd", {
    params ["_unit"];
    vgm_c_skill_passives_recon_followTheTracers_items deleteAt netId _unit;
}] call para_g_fnc_event_subscribeServer;
