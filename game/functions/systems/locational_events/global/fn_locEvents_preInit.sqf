/*
    File: fn_locEvents_preInit.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-16
    Public: No

    Description:
        Preinit for locational events.

    Parameter(s):
        N/A

    Returns:
        The initialised events data [HashMap]

    Example(s):
        N/A
 */

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";

if (isNil "_locEventsData") then {
    _locEventsData = createHashMapFromArray [
        ["listenerEventTypes", createHashMap],
        ["perceptionGroups", createHashMap]
    ];

    localNamespace setVariable ["vgm_l_locEvents_data", _locEventsData];
};

_locEventsData // return
