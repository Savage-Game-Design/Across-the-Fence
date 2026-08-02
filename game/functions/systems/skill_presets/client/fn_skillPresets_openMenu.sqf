/*
    File: fn_skillPresets_openMenu.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Open the skill presets dialog and request presets from server.

    Parameter(s):
        N/A

    Returns:
        Nothing
*/

createDialog "VGM_DisplaySkillPresets";

// Request latest presets from server
[player] remoteExecCall ["vgm_s_fnc_skillPresets_handle_fetchRequest", 2];
