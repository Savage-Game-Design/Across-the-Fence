/*
    File: fn_prestige_requestPrestige.sqf
    Author: Atlas
    Date: 2026-03-05
    Public: No

    Description:
        Request prestige from the server. Resets skills and level,
        increments prestige counter. Cosmetics are kept.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_prestige_requestPrestige
 */

// Save current loadout so cosmetics can be restored after prestige
missionNamespace setVariable ["vgm_c_prestige_savedLoadout", getUnitLoadout player];

isNil {["Waiting for server...", "Please wait", false, false] spawn BIS_fnc_guiMessage};

[player] remoteExecCall ["vgm_s_fnc_prestige_handle_request", 2];
