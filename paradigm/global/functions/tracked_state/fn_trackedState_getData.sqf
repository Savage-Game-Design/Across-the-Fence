/*
    File: fn_trackedState_getData.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-02-25
    Public: No

    Description:
        Fetches data for the tracked state system, creating it if necessary.

    Parameter(s):
        None

    Returns:
        Tracked state system data [HASHMAP]

    Example(s):
        private _trStateData = [] call para_g_fnc_trackedState_getData
 */

if !(isNil "para_l_trackedState_initialised") exitWith { localNamespace getVariable "tracked_state_system" };

localNamespace setVariable ["tracked_state_system", createHashMapFromArray [
    ["state", createHashMap],
    ["equalsHandlers", createHashMap],
    ["changedHandlers", createhashMap]
]];

para_l_trackedState_initialised = true;

localNamespace getVariable "tracked_state_system"
