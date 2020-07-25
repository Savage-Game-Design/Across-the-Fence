/*
  Author: Spoffy

  Description:
	Deletes a previously created namespace

  Params:
	_namespace - Namespace to delete

  Returns:
	None

  Example Usage:
	locationNull call vn_an_fnc_delete_namespace
*/

params ["_namespace"];

if (_namespace isEqualType locationNull) exitWith {
	deleteLocation _namespace;
};

deleteVehicle _namespace;