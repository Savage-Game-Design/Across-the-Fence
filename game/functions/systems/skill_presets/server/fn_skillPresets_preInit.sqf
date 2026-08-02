/*
    File: fn_skillPresets_preInit.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Server preInit for the skill presets system.
        Registers the "skillPresets" persistence schema.

    Parameter(s):
        N/A

    Returns:
        Nothing
*/

if (!isServer) exitWith {};

["skillPresets"] call vgm_s_fnc_persistence_registerSchema;
