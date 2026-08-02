/*
    File: fn_skillPresets_receivePresets.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Receive preset data from the server. Stores locally and refreshes the UI
        if the dialog is open.

    Parameter(s):
        _presets - Presets hashmap [HASHMAP]

    Returns:
        Nothing
*/

params ["_presets"];

vgm_c_skillPresets_data = _presets;

// Refresh UI if the skill presets dialog is currently open
private _display = uiNamespace getVariable ["vgm_displaySkillPresets", displayNull];
if (!isNull _display) then {
    ["refreshUI", [_display]] call vgm_c_fnc_displaySkillPresets;
};
