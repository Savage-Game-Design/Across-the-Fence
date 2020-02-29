/*
  Author: Aaron Clark and Spoffy

  Description:
	Converts a position config into an actual position.

  Params:
	_posConfig - Position config, in one of the valid formats

  Returns:
    A position that depends on the config.

  Example Usage:
	["marker", "marker_1"] call vn_mf_fnc_parse_pos_config
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