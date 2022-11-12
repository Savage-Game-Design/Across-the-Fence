/*
    File: fn_bf_respawn_on_functional.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Called when a respawn building starts functioning.
		Enables it as a respawn point.
    
    Parameter(s):
		_building - Building that became functional [OBJECT]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_building"];


private _currentSupplies = _building getVariable "para_g_current_supply_source" getVariable "para_g_current_supplies";
private _isRegistered = !(_building getVariable ["para_s_respawn_id", []] isEqualTo []);

if (_currentSupplies > para_s_bf_respawn_supply_cost && !_isRegistered) then {
	[_building] call para_s_fnc_bf_respawn_register_respawn;
};