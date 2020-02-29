/*
  Author: Aaron Clark

  Description:
	placed building handler

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params [
	["_object",objNull,[objNull]],
	["_new_object",objNull,[objNull]]
];

private _variables = allVariables _object;
// save all object variables
private _vardata = [];
{
	_var = _object getVariable _x;
	_vardata pushBack [_x,_var];
	_new_object setVariable [_x,_var,true]; // todo decide what vars to make public
} forEach _variables;

deleteVehicle _object;

diag_log format["swapbuilding %1 %2", _object,_new_object];

vn_mf_buildings pushBackUnique _new_object;
