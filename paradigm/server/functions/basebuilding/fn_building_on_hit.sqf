/*
    File: fn_building_on_hit.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        No description added yet.
    
    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_building"];

if (isNull _building || _building getVariable ["para_s_building_id", objNull] isEqualType objNull) exitWith {
	diag_log format ["WARNING: Paradigm: Building on hit called without a valid building by %1", _player];
};

//Commented out waiting on scripted handler being added to handgun weapons
//TODO - This
//if (!isNull _building/* && {currentWeapon _unit == "vn_m_shovel_01"}*/) then {

[_building, 0.2] call para_s_fnc_building_add_build_progress;