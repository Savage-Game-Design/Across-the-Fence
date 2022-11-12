/*
    File: fn_base_delete.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_base"];

{
	[_x] call para_s_fnc_building_disconnect_base;
} forEach (_base getVariable "para_g_buildings");

//Delete base marker if it exists
private _hqMarker = _base getVariable ["para_g_hq_marker", ""];
private _baseMarker = _base getVariable ["para_g_base_marker", ""];
{ deleteMarker _x } forEach [_hqMarker, _baseMarker];
[_baseMarker] call para_c_fnc_zone_marker_delete;

para_g_bases = para_g_bases - [_base];

deleteVehicle _base;

publicVariable "para_g_bases";
