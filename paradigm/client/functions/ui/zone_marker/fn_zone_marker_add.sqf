/*
    File: fn_zone_marker_add.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
        Adds the given marker the to the Zone Marker system.

    Parameter(s):
        _marker - Marker that should display information about the zone when hovered above [STRING, defaults to nil]

    Returns:
        Index of the marker in the zone marker list [NUMBER]

    Example(s):
        ["zone_locationName", "zone_type"] call para_c_fnc_zone_marker_add;
*/
params ["_marker", ["_type", "default"], ["_params", []]];
// Initialize hashmap if necessary
if (isNil "para_c_zone_markers_map") then {para_c_zone_markers_map = createHashMap};
// Add marker to list
para_c_zone_markers_map set [_marker, [_type, _params]];
//Sync with clients
publicVariable "para_c_zone_markers_map";
