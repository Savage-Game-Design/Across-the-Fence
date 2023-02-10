/*
    File: fn_trstate_data.sqf
    Author: Savage Game Design
    Date: 2023-02-09
    Last Update: 2023-02-09
    Public: No

    Description:
        Fetches data for the tracked state system, creating it if necessary.

    Parameter(s):
        None

    Returns:
        Tracked state system data [HASHMAP]

    Example(s):
        private _trStateData = [] call para_g_fnc_trstate_data
 */

if !(isNil "para_l_trState_initialised") exitWith { localNamespace getVariable "tracked_state_system" };

localNamespace setVariable ["tracked_state_system", createHashMapFromArray [
    ["state", createHashMap],
    ["equalsHandlers", createHashMap],
    ["changedHandlers", createhashMap]
]];

para_l_trState_initialised = true;

localNamespace getVariable "tracked_state_system"
