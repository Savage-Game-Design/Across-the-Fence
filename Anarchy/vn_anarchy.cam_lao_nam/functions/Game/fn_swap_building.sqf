/*
  Author: Aaron Clark

  Description:
	Swaps object while retaining exact position and direction.

  Example Usage:
	[vn_mf_obj_deliver_1,"Land_Barracks_01_grey_F",[0,0,0]] call	vn_mf_fnc_swap_building;

  Returns:
	NOTHING

  Parameter(s):
*/
params [
	"_obj",				// 0: OBJECT - existing object
	"_class",			// 1: STRING - new class if not defined uses
	["_offset",[0,0,0]]		// 1: ARRAY - Model offset (optional)
];

private _pos = getPosWorld _obj;
_pos set [2,0];


private _variables = allVariables _obj;
// save all object variables
private _vardata = [];
{
	_vardata pushBack [_x,(_obj getVariable _x)];
} forEach _variables;

// get client id that spawned object
private _clientID = owner _obj;
private _target = 0;

if (_clientID > 2) then
{
	_target = _clientID;
} else {
	// use HC or clients
	private _all_headlessclients = entities "HeadlessClient_F";
	private _all_players = allPlayers - _all_headlessclients;
	if !(_all_headlessclients isEqualTo []) then
	{
		_target = selectRandom _all_headlessclients;
	}
	else
	{
		if !(_all_players isEqualTo []) then
		{
			_target = selectRandom _all_players;
		};
	};
};

diag_log format["%1 target %2",_obj, _target];

// create new object server side
if (_target isEqualTo 0) then
{
	private _veh = createVehicle [_class, _pos, [], 0, 'CAN_COLLIDE'];
	_veh setVectorDirAndUp [vectorDir _obj, vectorUp _obj];
	[_obj,_veh] call vn_mf_fnc_swapbuilding;

// create object on client or HC
} else {
	[
		[[_class, _pos, [], 0, 'CAN_COLLIDE'],_obj],
		{
			params ["_create_arr","_object"];
			private _veh = createVehicle _create_arr;
			_veh setVectorDirAndUp [vectorDir _object, vectorUp _object];
			[player,"swapbuilding",[_object,_veh],player getVariable "vn_mf_token"] remoteExecCall ["vn_mf_fnc_rehandler",2];
		}
	] remoteExec ["call", _target];
};
