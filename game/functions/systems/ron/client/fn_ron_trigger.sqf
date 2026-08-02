/*
    File: fn_ron_trigger.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Client-side trigger for RON. Called from the wheel menu action.
        Sends the request to the server.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_ron_trigger;
 */

if (!hasInterface) exitWith {};

// Check cooldown client-side for responsiveness
if (missionNamespace getVariable ["vgm_s_ron_active", false]) exitWith {
    hint "RON already in progress.";
};

if (missionNamespace getVariable ["vgm_s_ron_voteInProgress", false]) exitWith {
    hint "RON vote already in progress.";
};

// Send to server
[player] remoteExecCall ["vgm_s_fnc_ron_execute", 2];

format ["RON: Vote requested by %1", name player] call vgm_g_fnc_logInfo;
