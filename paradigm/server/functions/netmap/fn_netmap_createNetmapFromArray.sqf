/*
    File: fn_netmap_makeIntoNamedNetmap copy.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        Initialises networking on a hashmap, and makes it available on the client using a random ID.

    Parameter(s):
        _hashMap - hashmap to network [HashMap]

    Returns:
        The original hashmap passed in as an argument.

    Example(s):
        private _myNetmap = createHashMap;
        [_myNetmap] call para_s_fnc_netmap_makeIntoNamedNetmap;

        // Need to access it some other way on the client.
 */

params ["_array"];

private _lastNetmapId = localNamespace getVariable ["para_s_lastNetmapId", 0];
private _thisNetmapId = _lastNetmapId + 1;
localNamespace setVariable ["para_s_lastNetmapId", _thisNetmapId];

[_thisNetmapId, _array] call para_s_fnc_netmap_createNamedNetmapFromArray;
