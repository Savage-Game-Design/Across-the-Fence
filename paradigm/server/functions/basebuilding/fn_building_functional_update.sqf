/*
    File: fn_building_functional_update.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Updates whether a building is functional or not, based on the definition of "functional".
        Currently defined purely by whether or not it has supplies, and whether it's built.
    
    Parameter(s):
        _building - Building to check [OBJECT]
    
    Returns:
        True if building is functional, false otherwise
    
    Example(s):
        [_building] call para_s_fnc_building_functional_update;
*/

params ["_building"];

private _supplySource = _building getVariable "para_g_current_supply_source";

//Decay if no supplies, or building is not yet built
private _functional = 
       _supplySource getVariable "para_g_current_supplies" > 0 
    && _building getVariable ["para_g_building_constructed", false];
private _previouslyFunctional = _building getVariable ["para_s_building_functional", false];

if (_functional != _previouslyFunctional) then 
{
    if (_functional) then
    {
        [_building] call para_s_fnc_building_on_functional;
    } 
    else
    {
        [_building] call para_s_fnc_building_on_non_functional;
    };

    _building setVariable ["para_s_building_functional", _functional, true];
};

_functional
