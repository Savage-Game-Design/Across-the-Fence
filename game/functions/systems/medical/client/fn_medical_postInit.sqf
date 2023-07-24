/*
    File: fn_medical_postInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-07-24
    Public: No

    Description:
        Client postInit for medical component.
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_advanced_revive" isNotEqualTo []) then {
    "S.O.G. Advanced Revive module detected in the mission. VGM Medical will NOT function corectly!" call vgm_g_fnc_logError;
};

vgm_c_medical_eh = player addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];

// tell other clients to add actions on our player unit
["vgm_medical_addAction", player] call para_g_fnc_event_triggerGlobal;

// add the actions on players that were present before we joined and ourselves
{
    ["vgm_medical_addAction", _x] call para_g_fnc_event_triggerLocal;
} forEach (allPlayers select {!(_x isKindOf "VirtualMan_F")});

// bleeding status effect
["bleeding", {call vgm_c_fnc_medical_statusEffectBleeding}] call vgm_c_fnc_statusEffect_create;

// setup blood effect overlay
call {
    "vgm_medical_blood" cutRsc ["vgm_RscHealthTextures", "PLAIN"];

    // values taken from BIS_fnc_bloodEffect
    private _x = ((0 * safezoneW) + safezoneX) + ((safezoneW - (2.125 * safezoneW * 3/4)) / 2);
    private _y = (-0.0625 * safezoneH) + safezoneY;
    private _w = 2.125 * safezoneW * 3/4;
    private _h = 1.125 * safezoneH;

    private _display = uiNamespace getVariable "vgm_RscHealthTextures";

    private _texUpper = _display displayctrl 1213;
    private _texMiddle = _display displayctrl 1212;
    private _texLower = _display displayctrl 1211;

    _texLower ctrlsetposition [_x, _y, _w, _h];
    _texMiddle ctrlsetposition [_x, _y, _w, _h];
    _texUpper ctrlsetposition [_x, _y, _w, _h];
};
