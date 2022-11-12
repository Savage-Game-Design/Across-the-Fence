/*
    File: fn_building_is_decaying.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Checks whether a building is in the "decay" state
    
    Parameter(s):
		_building - Building to check [NAMESPACE]
    
    Returns:
		True if building is decaying, false otherwise [BOOL]
    
    Example(s):
		[cursorObject getVariable "para_g_building"] call para_g_fnc_building_is_decaying
*/

params ["_building"];

private _supplySource = _building getVariable ["para_g_current_supply_source", objNull];

if (isNull _supplySource) exitWith {diag_log "ERROR: Paradigm: 'Is decaying' check called on a building without a supply source";};

//Decay if no supplies, or building is not yet built
_supplySource getVariable "para_g_current_supplies" <= 0 || !(_building getVariable ["para_g_building_constructed", false])