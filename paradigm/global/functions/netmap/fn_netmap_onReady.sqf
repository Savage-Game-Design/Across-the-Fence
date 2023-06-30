/*
    File: fn_netmap_onReady.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Calls the provided callback when the netmap system is ready to be used.

        Primarily used on clients, to inform them that all the netmaps have been downloaded from the server.

    Parameter(s):
        _callback - Callback, in the same format used for the event system [CODE/ARRAY]

    Returns:
        Nothing

    Example(s):
        [{ diag_log "System ready"}] call para_g_fnc_netmap_onReady
 */

params ["_callback"];

if !(_callback isEqualType []) then {
    _callback = [[], _callback];
};

// Netmaps are always ready on the server, as the server doesn't need to fetch them.
if (isServer || localNamespace getVariable ["vgm_netmaps_ready", false]) exitWith {
    [[], _callback # 0] call (_callback # 1);
};

["netmaps ready", _callback] call para_g_fnc_event_subscribeLocal;
