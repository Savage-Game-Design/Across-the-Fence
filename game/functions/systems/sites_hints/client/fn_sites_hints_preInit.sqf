#include "script_component.inc"
/*
    File: fn_sites_hints_preInit.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2025-01-01
    Public: No

    Description:
        Client Preinit for the site hints system.
 */

if (!hasInterface) exitWith {};

vgm_sites_hints_objectsList = [];
vgm_sites_hints_markers = [];

vgm_sites_hints_glintTextures = [];
vgm_sites_hints_glintTextures resize (GLINT_FRAMES+1);
{
    vgm_sites_hints_glintTextures set [
        _forEachIndex,
        getMissionPath format ["assets\glint\vnx_atf_glint_0%1_ca", _forEachIndex]
    ]
} forEach vgm_sites_hints_glintTextures;

vgm_sites_hints_placementModifiers = createHashMapFromArray [
    ["Land_vn_canisterfuel_f", {
        // canisters should be placed on their side
        private _pos = getPosATL _this;
        _pos set [2, 0.05];

        _this setVectorUp surfaceNormal getPosATL _this;

        (_this call BIS_fnc_getPitchBank) params ["_pitch"];
        [_this, _pitch - 90, 0] call BIS_fnc_setPitchBank;

        _this setPosATL _pos;
    }]
];

["vgm_mission_deploy_local", {
    {deleteMarkerLocal _x} forEach vgm_sites_hints_markers;
    vgm_sites_hints_markers = [];
}] call para_g_fnc_event_subscribeLocal;

["vgm_mission_end_local", {
    vgm_sites_hints_objectsList = [];
}] call para_g_fnc_event_subscribeServer;

["glintFrequency"] call vgm_c_fnc_coefficient_create;
