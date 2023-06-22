/*
    File: fn_netmap_onReady.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_callback"];

if !(_callback isEqualType []) then {
    _callback = [[], _callback];
};

if (localNamespace getVariable ["vgm_netmaps_ready", false]) then {
    [[], _callback # 0] call (_callback # 1);
} else {
    ["netmaps ready", _callback] call para_g_fnc_event_subscribeLocal;
};
