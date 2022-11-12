/*
	File: fn_loadbal_create_squad.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Create a squad and load-balance it to all connected clients.
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/

params [["_units", []], "_groupTarget", "_position"];

// Create it on the server, to avoid an FPS stutter on a client. Also, easier to get a reference to them.
// Generally speaking, the rest of the systems assume a squad is created on the server.
private _squad = _this call para_g_fnc_create_squad;

private _group = _squad select 1;

//Set the squad's locality to the client with highest FPS
private _selectedClient = call para_s_fnc_loadbal_suggest_host;
_group setGroupOwner _selectedClient;
_group setVariable ["groupClientOwner", _selectedClient];

//Update the owner variable if the group changes locality.
//Can't run this on the group itself - need to use the units in it.
{
	_x addEventHandler ["Local", {
		params ["_unit", "_isLocal"];
		if (_isLocal) then {
			group _unit setVariable ["groupClientOwner", clientOwner, true];
		};
	}];
} forEach units _group;

_squad
