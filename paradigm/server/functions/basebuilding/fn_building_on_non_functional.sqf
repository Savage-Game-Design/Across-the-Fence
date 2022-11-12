/*
    File: fn_building_on_non_functional.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Called when a building becomes non-functional
    
    Parameter(s):
		_building - Building that stopped being functional [OBJECT]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
		[_building] call para_s_fnc_building_on_non_functional
*/

params ["_building"];

[_building, "onBuildingNonFunctional", [_building]] call para_g_fnc_building_fire_feature_event;