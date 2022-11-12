/*
    File: fn_bf_respawn_on_supplies_changed.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Called when the amount of supplies in a building changes.
    
    Parameter(s):
        _building - Building which has a new supply value [OBJECT]
		_newSupplies - New quantity of supplies [NUMBER]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_building", "_newSupplies"];

private _isRegistered = !(_building getVariable ["para_s_respawn_id", []] isEqualTo []);

if (_newSupplies < para_s_bf_respawn_supply_cost && _isRegistered) then {
	[_building] call para_s_fnc_bf_respawn_unregister_respawn;
};

if (_newSupplies > para_s_bf_respawn_supply_cost && !_isRegistered) then {
	[_building] call para_s_fnc_bf_respawn_register_respawn;
};
