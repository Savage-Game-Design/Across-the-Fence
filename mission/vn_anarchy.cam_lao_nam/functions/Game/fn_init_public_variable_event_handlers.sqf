/*
  Author: Aaron Clark

  Description:
	Event handler for player object variables

  Example Usage:
	call vn_an_fnc_init_public_variable_event_handlers;

*/
{
	_x params ["_name", "_function"];
	// set handler and use already compiled functions
	format["vn_an_%1",_name] addPublicVariableEventHandler [player, missionNamespace getVariable [_function,{}]];
} forEach getArray(missionConfigFile >> "gamemode" >> "stats" >> "tracking" );
