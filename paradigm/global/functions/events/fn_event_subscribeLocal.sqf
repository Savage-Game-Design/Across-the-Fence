/*
    File: fn_event_subscribeLocal.sqf
    Author:
    Date: 2022-11-24
    Last Update: 2022-11-24
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

([[clientOwner]] + _this) call para_g_fnc_event_subscribe;
