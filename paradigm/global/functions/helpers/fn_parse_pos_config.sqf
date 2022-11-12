/*
    File: fn_parse_pos_config.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Converts a position config into an actual position.
    
    Parameter(s):
        _posConfig - Position config, in one of the valid format [String]
        _data - Data [String]
    
    Returns:
        A position that depends on the config [Position]
    
    Example(s):
        ["marker", "marker_1"] call para_g_fnc_parse_pos_config;
*/

params ["_type","_data"];

switch (_type) do
{
    case ("marker"):
    {
        getMarkerPos _data
    };
    case ("task"):
    {
        _data call BIS_fnc_taskDestination
    };
    case ("object"):
    {
        getPos (missionNamespace getVariable [_data, objNull])
    };
    case ("objectid"):
    {
        getPos objectFromNetId _data
    };
    case ("group"):
    {
        getPos leader (missionNamespace getVariable [_data, objNull])
    };
    case ("groupid"):
    {
        getPos leader groupFromNetId _data
    };
    case ("object2"):
    {
        [missionNamespace getVariable [_data, objNull], 5]
    };
    case ("random"):
    {
        _data call BIS_fnc_randomPos
    };
}