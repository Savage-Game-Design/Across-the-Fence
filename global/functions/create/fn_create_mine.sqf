/*
	File: fn_create_mine.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Wrapper around script command 'createMine'.

	Parameter(s):
		// Same as 'createMine'
	
	Returns:
		Created Mine, or objNull if not possible [Object]

	Example(s): none
*/

params ["_type", "_position", ["_markers", []], ["_placement", 0]];

createMine [_type, _position, _markers, _placement];