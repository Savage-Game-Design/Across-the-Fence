/*
    File: fn_zone_marker_get_info.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Internal use. Updates the zone marker hashMap with hostile zone info

    Parameter(s):
        _marker - Zone marker [STRING, defaults to nil]

    Returns:
        Information about the zone [TEXT]

    Example(s):
        ["base_locationName"] call para_c_fnc_zone_marker_fob_info;
*/
params ["_marker", ["_params", []]];

_params params [["_baseName", _marker]];

// Capitalize name
private _formattedBaseName = toUpper _baseName;
// Aquire supply info
private _base = nearestObject [getMarkerPos _marker, "Building"]; // Find nearest building to marker - should always return the basestarter
[_base] call para_c_fnc_buildable_resupply_info params [["_percentFull", "Initializing"], "_currentSupplies", "_suppliesUntilFull", "_lifetimeSecs", "_supplyCapacity"];
private _info = "";
if (_percentFull isEqualType 6.9) then {
  _info = [
    _formattedBaseName,
    format [localize "STR_para_overlay_buildable_percentage_filled", _percentFull * 100 toFixed 1],
    format [localize "STR_para_overlay_buildable_current_supplies", _currentSupplies toFixed 1],
    format [localize "STR_para_overlay_buildable_supplies_until_full", _suppliesUntilFull toFixed 1],
    format [localize "STR_para_overlay_buildable_supply_capacity", _supplyCapacity toFixed 0],
    format [localize "STR_para_overlay_buildable_lifetime", str floor (_lifetimeSecs / 3600), str floor ((_lifetimeSecs % 3600) / 60)]
  ];
} else {
  _info = [
    _formattedBaseName,
    format [localize "STR_para_overlay_buildable_percentage_filled", _percentFull],
    format [localize "STR_para_overlay_buildable_current_supplies", _percentFull],
    format [localize "STR_para_overlay_buildable_supplies_until_full", _percentFull],
    format [localize "STR_para_overlay_buildable_lifetime", _percentFull]
  ];
};
_info
