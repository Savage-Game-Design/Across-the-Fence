/*
    File: fn_prestige_receivePrestige.sqf
    Author: Atlas
    Date: 2026-03-05
    Public: No

    Description:
        Handle receiving prestige response from the server.
        Dismisses the waiting dialog, restores the player's cosmetic loadout,
        and shows a prestige notification.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_prestige_receivePrestige", _player]
 */

"Received prestige response" call vgm_g_fnc_logInfo;

// Dismiss the BIS_fnc_guiMessage popup
uiNamespace setVariable ["BIS_fnc_guiMessage_status", true];

// Restore the saved loadout (preserves arsenal cosmetics)
private _savedLoadout = missionNamespace getVariable ["vgm_c_prestige_savedLoadout", nil];
if (!isNil "_savedLoadout") then {
    player setUnitLoadout _savedLoadout;
    missionNamespace setVariable ["vgm_c_prestige_savedLoadout", nil];
};

private _levelingData = player getVariable ["vgm_g_levelingData", createHashMap];
private _prestige = _levelingData getOrDefault ["prestige", 0];
private _displayLevel = _prestige * 30 + (_levelingData getOrDefault ["level", 0]);

hint format ["Prestige %1 achieved! You are now level %2.", _prestige, _displayLevel];
