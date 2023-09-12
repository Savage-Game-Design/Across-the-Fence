/*
    File: fn_medical_postInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-09-02
    Public: No

    Description:
        Client postInit for medical component.
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_advanced_revive" isNotEqualTo []) then {
    "S.O.G. Advanced Revive module detected in the mission. VGM Medical will NOT function corectly!" call vgm_g_fnc_logError;
};

vgm_c_medical_handleDamageEH = player addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];
vgm_c_medical_respawnEH = player addEventHandler ["Respawn", {
    params ["_unit"];
    {_unit setVariable [_x, nil]} forEach (allVariables _unit select {_x find "vgm_g_medical_wound$" == 0});
}];

// tell other clients to add actions on our player unit
["vgm_medical_addAction", player] call para_g_fnc_event_triggerGlobal;

// add the actions on players that were present before we joined and ourselves
{
    ["vgm_medical_addAction", _x] call para_g_fnc_event_triggerLocal;
} forEach (allPlayers select {!(_x isKindOf "VirtualMan_F")});

// bleeding status effect
["bleeding", {call vgm_c_fnc_medical_statusEffectBleeding}] call vgm_c_fnc_statusEffect_create;

[] call vgm_c_fnc_medical_feedback_init;
[] call vgm_c_fnc_medical_injuryEffects_init;
