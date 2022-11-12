/*
	File: fn_create_vehicle.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Wrapper around script command 'createVehicle'.
	
	Parameter(s):
		// Same as 'createVehicle'
	
	Returns:
		Created vehicle, or objNull if not possible [Object]
	
	Example(s): none
*/

params ["_type", "_position", ["_markers", []], ["_placement", 0], ["_special", "NONE"]];

createVehicle [_type, _position, _markers, _placement, _special];