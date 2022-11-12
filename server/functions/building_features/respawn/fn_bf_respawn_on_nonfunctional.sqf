/*
    File: fn_bf_respawn_on_nonfunctional.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Called when a respawn building stops functioning.
        Disables the respawn point.
    
    Parameter(s):
        _building - Building that stopped being functional. [OBJECT]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/
params ["_building"];

private _isRegistered = !(_building getVariable ["para_s_respawn_id", []] isEqualTo []);

if (_isRegistered) then {
    [_building] call para_s_fnc_bf_respawn_unregister_respawn;
};