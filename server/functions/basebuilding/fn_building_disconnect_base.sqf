/*
    File: fn_base_disconnect_building.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Removes a building from its current base.
    
    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_building"];

private _base = _building getVariable ["para_g_base", objNull];
if (isNull _base) exitWith {};

[_building, "onBaseDisconnected", [_building, _base]] call para_g_fnc_building_fire_feature_event;

//Update references
_building setVariable ["para_g_base", nil, true];
_base setVariable ["para_g_buildings", (_base getVariable "para_g_buildings") - [_building], true];

//Set the building to use its own supply source
//Will also disconnect it from its current supply source
[_building, _building getVariable "para_g_internal_supply_source"] call para_s_fnc_building_connect_supply_source;

