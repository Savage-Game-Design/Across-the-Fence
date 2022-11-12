/*
    File: fn_base_create.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        _pos - Position to place the base at [ARRAY]
        _baseName - Name of the base (optional) [STRING]
        _baseRadius - Size of the base area [NUMBER]
        _initialSupplies - Number of supplies to initially put in the base (optional) [NUMBER]
        _id - ID of the base. Should not be provided unless loading from a save [NUMBER]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_pos", "_baseName", ["_baseRadius", para_g_max_base_radius], ["_initialSupplies", 0], "_id"];

if (isNil "_id") then
{
    // Create building IDs.
    (["GET", "base_counter", 0] call para_s_fnc_profile_db) params ["","_baseCounter"];
    _id = _baseCounter + 1;
    (["SET", "base_counter", _id] call para_s_fnc_profile_db);
};

//Create the base. Using a simple object, as we want to use the position.
private _base = createSimpleObject ["a3\weapons_f\empty.p3d", AGLToASL _pos];
_base setVariable ["para_g_base_id", _id, true];
//TODO - Make bases upgradable, etc.
_base setVariable ["para_g_base_radius", _baseRadius, true];

if (isNil "_baseName") then
{
    private _number = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    private _phoenetic = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Indigo", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Siera", "Tango", "Uniform", "Victor", "Whisky", "Xray", "Yankee", "Zulu"];
    _baseName = selectRandom _phoenetic + "-" + selectRandom _number + selectRandom _number;
};
_base setVariable ["para_g_base_name", _baseName, true];

_hqMarkerName = "hq_" + _basename;
//Todo: set markers in side chat - will need a way to determine side (team) of base
_hqMarker = createMarkerLocal [_hqMarkerName, _base];
//Todo: vary marker type (colour) based on side
_hqMarker setMarkerTypeLocal "b_hq";
// Set color and send to clients
_hqMarker setMarkerText _baseName;

_baseMarkerName = "base_" + _basename;
_baseMarker = createMarkerLocal [_baseMarkerName, _base];
_baseMarker setMarkerSizeLocal [250, 250];
_baseMarker setMarkerShapeLocal "ELLIPSE";
_baseMarker setMarkerAlphaLocal 0.25;
// Set color and send to clients
_baseMarker setMarkerColor "colorBLUFOR";

_base setVariable ["para_g_hq_marker", _hqMarkerName, true];
_base setVariable ["para_g_base_marker", _baseMarkerName, true];
[_baseMarker, "fob", [_baseName]] call para_c_fnc_zone_marker_add;

//TODO - Make these parameters? I'm not quite sure how this should work.
[_base, 10000, _initialSupplies] call para_s_fnc_supply_source_create;
_base setVariable ["para_g_supply_source", _base, true];
_base setVariable ["para_g_buildings", [], true];

para_g_bases pushBack _base;
publicVariable "para_g_bases";

//Base created, now claim any unclaimed nearby buildings
{
    if !(_x getVariable ["para_g_base", objNull] isEqualTo _base) then {
        [_x, _base] call para_s_fnc_building_connect_base;
    };
} forEach (para_l_buildings inAreaArray [_pos, _baseRadius, _baseRadius]);

_base
