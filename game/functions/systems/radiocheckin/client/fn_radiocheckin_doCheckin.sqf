/*
    File: fn_radiocheckin_doCheckin.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Called when the group leader uses the "Radio Check-In" wheel menu action.
        Calls the server function directly to reset the timer and play voice lines.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_radiocheckin_doCheckin;
*/

if (leader player != player) exitWith {};

// Block if player is inside a radio jammer's radius
private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
if (_jamDist >= 0) exitWith {
    hint format [localize "STR_VGM_RADIO_JAMMED", (round (_jamDist / 100)) * 100];
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

[] remoteExecCall ["vgm_s_fnc_radiocheckin_onCheckin", 2];

hint localize "STR_VGM_RADIOCHECKIN_HINT_SENT";
